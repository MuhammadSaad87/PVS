;;;
;;; RAHD: Real Algebra in High Dimensions v0.5
;;; A feasible decision method for the existential theory of real closed fields.
;;;
;;; ** Ideal triviality checking,
;;;    Morphism of terms in case inequalities into their canonical representatives in
;;;     the residue class ring induced by the ideal generated by the case equational
;;;     constraints, 
;;;    A heuristic search for scalar-valued variables (polynomial ring indeterminates) by 
;;;     examining a bounded canonical representative power sequence in the residue class 
;;;     ring induced by the ideal generated by the case equational constraints (which
;;;     then induces a special treatment of literals with irrational real algebraic terms 
;;;     by a Cauchy sequence comparison evaluator for exact real arithmetic),
;;;    
;;;   all via reduced Groebner bases. **
;;;
;;; Written by Grant Olney Passmore
;;; Ph.D. Student, University of Edinburgh
;;; Visiting Fellow, SRI International
;;; Contact: g.passmore@ed.ac.uk, http://homepages.inf.ed.ac.uk/s0793114/
;;; 
;;; This file: began on         18-Sept-2008,
;;;            last updated on  21-Nov-2009.
;;;

(in-package :rahd)

;;;
;;; TRIVIAL-IDEAL:
;;;
;;; Given a conjunctive case, is the ideal generated by the collection of
;;; equalities in the case trivial (e.g., the entire polynomial ring)?  
;;; Equivalently, is the system of equations in the case unsatisfiable 
;;; over the complex numbers?
;;; If so, it is unsatisfiable over the reals as well.
;;; 

(defun trivial-ideal (c)
  (let ((eqs (gather-eqs c)))
    (if eqs (let ((c-reduced-gbasis (reduced-gbasis-for-case c)))
	      (if (equal c-reduced-gbasis '(((1))))
		  `(:UNSAT :EQS-GENERATE-TRIVIAL-IDEAL-OVER-COMPLEXES)
		c))
      c)))

;;; 
;;; INEQS-OVER-QUOTIENT-RING:
;;;
;;; Given a conjunctive case, return the result of simplifying every term
;;; in strict inequalities by reducing them to their canonical representative
;;; in the quotient ring induced by the ideal generated by the equations
;;; in the case, as given by the current var/term ordering via a reduced GBasis.
;;;
;;; Note: We are re-computing the reduced GBasis here, when we already do it
;;; above for trivial-ideal.  We should cache this in the future.
;;; Note: In answer to the above note, GBases are now cached when possible!
;;;

(defun ineqs-over-quotient-ring (c)
  (let ((eqs (gather-eqs c))
	(ineqs (gather-strict-ineqs c)))
    (if (and eqs ineqs) 
	(let ((c-reduced-gbasis
	       (reduced-gbasis-for-case c)))
	  (let ((adjusted-case 
		 (append eqs (mapcar #'(lambda (l) 
					 (lit-over-quotient-ring 
					  l 
					  c-reduced-gbasis)) 
				     ineqs))))
	    (if (not (and (subsetp c adjusted-case :test #'equal) 
			  (subsetp adjusted-case c :test #'equal))) 
		adjusted-case c)))
      c)))

;;;
;;; Given a literal and a reduced Groebner basis, return the residue of
;;; that literal over the quotient ring induced by the Groebner basis.
;;;

(defun lit-over-quotient-ring (l rgbasis)
  (if (void-gbasis rgbasis) 
      l
    (let ((op (car l))
	  (x  (cadr l))
	  (y  (caddr l)))
					;(assert (and (numberp y) (= y 0)))
      (let ((residue-x (poly-alg-rep-to-prover-rep 
			(cdr (poly-multiv-/ (poly-prover-rep-to-alg-rep x) rgbasis))))
	    (residue-y (if (equal y 0) 0 
			 (poly-alg-rep-to-prover-rep
			  (cdr (poly-multiv-/ (poly-prover-rep-to-alg-rep y) rgbasis))))))
	`(,op ,residue-x ,residue-y)))))


;;;
;;; FERTILIZE-SCALAR-VARS-OVER-QUOTIENT-RING:
;;;
;;; Given a conjunctive case, we heuristically search to see if each variable in the
;;;  current quotient ring is implied to be zero-valued by the equational constraints
;;;  in the case.  We do this by iteratively rewriting a sequence of powers of each
;;;  variable modulo the ideal generated by the equational constraints, and stop either
;;;  if a set exponent bound is reached or if any of the powers rewrite to 0.  If a power is
;;;  rewritten to 0, then we conjoin an assignment of that variable to 0 to the case
;;;  (since we are in an integral domain).  We then will rely on the waterfall to next
;;;  call DEMOD-NUM to take advantage of this dimensional reduction.
;;;
;;; ** Note: This has now been enhanced to include exact real algebraic roots of rational
;;;     numbers, not just for zeroing indeterminates.  See the comment banner in prover.lisp
;;;     (rcr-svars) for more specifics.
;;;
;;; ** Note: We now also include the following technique:
;;;           If v^k is rewritten to q where q is a rational, then:
;;;            (i) if q>0 and k is even,
;;;                  we conjoin a waterfall disjunction (:OR) with two subgoals:
;;;                   (i.0) one with (= v (EXACT-REAL-EXPT q 1/k)), and
;;;                   (i.1) one with (= v (- 0 (EXACT-REAL-EXPT q 1/k))).
;;;           (ii) if q>0 and k is odd, we simply add the positive rewrite to the case.
;;;

(defun fertilize-scalar-vars-over-quotient-ring (c &optional (expt-scalar 1))
  (let ((eqs (gather-eqs c)))
    (if (not eqs) c 
      (let ((c-reduced-gbasis (reduced-gbasis-for-case c))
	    (c-new-eqs nil)
	    (c-waterfall-disjunction? nil))
	(if c-reduced-gbasis
	    (progn
	      (let ((expt-bound (* (1+ expt-scalar) (eval (append '(max) (mapcar #'poly-deg c-reduced-gbasis))))))
		(dotimes (var-id (length *vars-table*))
		  (let ((cur-vp `((1 (,var-id . 1)))))
		    (loop for p from 1 to expt-bound do
			  (let ((vp-over-quotient-ring (cdr (poly-multiv-/ cur-vp c-reduced-gbasis))))
			    (let ((vp-over-quotient-ring-prover-rep (poly-alg-rep-to-prover-rep vp-over-quotient-ring)))
			      (fmt 9 "~% ~D --> ~D~%" 
				   (write-to-string (poly-alg-rep-to-prover-rep cur-vp))
				   vp-over-quotient-ring-prover-rep)
			      (if (or (equal vp-over-quotient-ring nil)
				      (equal vp-over-quotient-ring 0))
				  (return (setq c-new-eqs (append `((= ,(nth var-id *vars-table*) 0)) c-new-eqs)))		    
				(if (and (numberp vp-over-quotient-ring-prover-rep)
					 (not (< vp-over-quotient-ring-prover-rep 0))
					 (nth-root-rational? (poly-alg-rep-to-prover-rep vp-over-quotient-ring) p))
			      
				    ;;
				    ;; We've derived that v = q^k, with v>0, where 
				    ;;  v = (nth var-id *vars-table*),
				    ;;  q = (poly-alg-rep-to-prover-rep vp-over-quotient-ring)
				    ;;  k = p
				    ;;
				    ;; So, if k is even, then we return a waterfall disjunction of the following form:
				    ;;
				    ;;   (:OR (= v (expt q 1/k) 
				    ;;        (= v (- 0 (expt q 1/k)))), where expt is our special :EXACT-REAL-EXPT algebraic
				    ;;    number exponential.
				    ;;
				    ;; If k is odd, we return only the positive case.
				    ;;
				    ;; Note: Right now, we will only do this if (expt q 1/k) is rational.
				    ;;

				    (cond ((oddp p) (return (setq c-new-eqs
								  (append `((= ,(nth var-id *vars-table*)
									       ,(EXACT-REAL-EXPT
										 (poly-alg-rep-to-prover-rep vp-over-quotient-ring)
										 (/ 1 p))))
									  c-new-eqs))))
					  (t (setq c-waterfall-disjunction? t)
					     (return (setq c-new-eqs 
							   (append `((:OR (= ,(nth var-id *vars-table*)
									     ,(EXACT-REAL-EXPT
									       (poly-alg-rep-to-prover-rep vp-over-quotient-ring) 
									       (/ 1 p)))
									  (= ,(nth var-id *vars-table*)
									     (- 0 ,(EXACT-REAL-EXPT
										    (poly-alg-rep-to-prover-rep vp-over-quotient-ring) 
										    (/ 1 p))))))
								   c-new-eqs)))))))))
			  (setq cur-vp `((1 (,var-id . ,(+ p 1)))))))))
	
	;; Did we introduce a waterfall disjunction?  If so, we flag this fact for GENERIC-TACTIC.
	
	(let ((adj-case (append c-new-eqs c)))
	  (if (not c-waterfall-disjunction?) 
	      adj-case
	    (cons ':DISJ adj-case))))
	c)))))

;;;
;;; Given a conjunctive case, return the reduced GBasis of all equations in the case.
;;; This takes advantages of *GBASIS-CACHE* for caching GBases.
;;;

(defun reduced-gbasis-for-case (c)
  (let ((eqs (gather-eqs c)))
    (if (not eqs) nil
      (multiple-value-bind (gbasis-hash-val gbasis-hash-exists?)
			   (gethash eqs *gbasis-cache*)
        (if gbasis-hash-exists?

	    ;; GBasis is already in the cache, so we returen the cached value

	    gbasis-hash-val

	  ;; Otherwise, we have to compute it.

	  (let ((gbasis-for-case
		 
		 ;; Should we let CoCoA do our GBasis computations?

		 (if *gbasis-use-cocoa*

		     ;; Note: EXEC-COCOA-GB-FOR-CASE will internally ZRHS-reduce equations.

		     (exec-cocoa-gb-for-case eqs)

		   ;; Otherwise, we ZRHS-reduce and use our internal GBasis routines.
		   
		   (let ((prepd-raw-generators
			  (remove-if #'(lambda (x) (or (equal x 0) (equal x nil))) 
				     (mapcar #'(lambda (l) 
						 (let ((cur-x (cadr l))
						       (cur-y (caddr l)))
						   (if (not (equal cur-y 0))
						       (poly-prover-rep-to-alg-rep 
							`(- ,cur-x ,cur-y))
						     (poly-prover-rep-to-alg-rep cur-x))))
					     eqs))))

		     (if prepd-raw-generators 
			 (reduce-gbasis (gbasis prepd-raw-generators)) 
		       '(((0))))))))

		;; Place newly computed GBasis in cache and return it

		(setf (gethash eqs *gbasis-cache*) gbasis-for-case)

		;(format *standard-output* "GBasis wasn't found: gbasis-hash-val = ~D" gbasis-hash-val)

		gbasis-for-case))))))

;;;
;;; Is a GBasis `void'?  That is, does it give us no information?
;;;  Example: Computing a GB from equational constraint (= x x).
;;;

(defun void-gbasis (gbasis)
  (equal gbasis '(((0)))))

;;;
;;; Given a conjunctive case, return the subset of (in)equalities in the case.
;;; Note: We assume SIMP-ZRHS has already been run on the case, so that
;;;  the RHS of every equation is 0.
;;;

(defun gather-eqs (c)
  (remove-if-not #'(lambda (l) (equal (car l) '=)) c))

(defun gather-strict-ineqs (c)
  (remove-if-not #'(lambda (l) (or (equal (car l) '<) (equal (car l) '>))) c))

(defun gather-soft-ineqs (c)
  (remove-if-not #'(lambda (l) (or (equal (car l) '<=) (equal (car l) '>=))) c))

(defun gather-all-ineqs (c)
  (remove-if-not 
   #'(lambda (l)
       (let ((op (car l)))
	 (or (equal op '<)
	     (equal op '<=)
	     (equal op '>)
	     (equal op '>=))))
   c))
