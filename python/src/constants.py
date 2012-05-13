
# This File contans all the global constant strings used in the system

import wx
import logging

IMAGE_FOLDER_NAME = "images"
IMAGE_FOLDER_PATH = None
APPLICATION_FOLDER = None
LOGGER_LEVEL = logging.DEBUG

PVS_U = "PVS"
PVS_L = "pvs"
PVS_EXTENSION = ".pvs"
FULLNAME = "fullname"
ID_U = "ID"
ID_L = "id"

LABEL_FILE = "File"
LABEL_EDIT = "Edit"
LABEL_VIEW = "View"
LABEL_NEW = "New"
LABEL_OPEN = "Open"
LABEL_SAVE = "Save"
LABEL_SAVEAS = "Save As"
LABEL_SAVEALL = "Save All"
LABEL_QUIT = "Quit"
LABEL_UNDO = "Undo"
LABEL_SELECTALL = "Select All"
LABEL_COPY = "Copy"
LABEL_CUT = "Cut"
LABEL_PASTE = "Paste"
LABEL_FIND = "Find"
LABEL_REPLACE = "Replace"
LABEL_STARTPVS = "Start " + PVS_U
LABEL_STOPPVS = "Stop " + PVS_U
LABEL_TYPECHECK = "Typecheck"
LABEL_CLOSEFILE = "Close File"
LABEL_PROVE_FORMULA = "Prove This"

DOTDOTDOT = "..."
EMPTY_STRING = ""
FRAME_TITLE = "PVS Editor"
NEWLINE = "\n"
LOGGERNAME = "PVSEditor"

TAB_FILES = "Files"
TAB_BUFFERS = "Buffers"
LABEL_PROOF_PANEL = "Proof Tree"
LABEL_PVS_CONSOLE = "PVS Console"

PVS_MODE = "PVS Mode: "
PVS_MODE_OFF = "Off"
PVS_MODE_EDIT = "Editor"
PVS_MODE_PROVER = "Prover"
PVS_MODE_UNKNOWN = "Unknown"

MESSAGE_INITIALIZE_CONSOLE = "INITIALIZE CONSOLE"
MESSAGE_UPDATE_FRAME = "UPDATE FRAME"
MESSAGE_CONSOLE_WRITE_LINE = "CONSOLE WRITE LINE"
MESSAGE_CONSOLE_WRITE_PROMPT = "CONSOLE WRITE PROMPT"
MESSAGE_PVS_STATUS = "PVS STATUS"

THEORIES = "theories"
DECLARATIONS = "declarations"
KIND = "kind"
FORMULA_DECLARATION = "formulaDecl"
ERROR = "Error"
WARNING = "Warning"
MESSAGE = "Message"
FILE = "File"
THEORY = "Theory"
FORMULA = "Formula"
ROOT = "Root"
INPUT_LOGGER = "-logger"
LOG_LEVEL_DEBUG = "debug"
LOG_LEVEL_OFF = "off"

PVS_KEYWORDS = u'and conjecture fact let table andthen containing false library then array conversion forall macro theorem assuming conversion+ formula measure theory assumption conversion- from nonempty_type true auto_rewrite corollary function not type auto_rewrite+ datatype has_type o type+ auto_rewrite- else if obligation var axiom elsif iff of when begin end implies or where but endassuming importing orelse with by endcases in postulate xor cases endcond inductive proposition challenge endif judgement recursive claim endtable lambda sublemma closure exists law subtypes cond exporting lemma subtype_of'

#('and', 'conjecture', 'fact', 'let', 'table', 'andthen', 'containing', 'false', 'library', 'then', 'array', 'conversion', 'forall', 'macro', 'theorem', 'assuming', 'conversion+', 'formula', 'measure', 'theory', 'assumption', 'conversion-', 'from', 'nonempty_type', 'true', 'auto_rewrite', 'corollary', 'function', 'not', 'type', 'auto_rewrite+', 'datatype', 'has_type', 'o', 'type+', 'auto_rewrite-', 'else', 'if', 'obligation', 'var', 'axiom', 'elsif', 'iff', 'of', 'when', 'begin', 'end', 'implies', 'or', 'where', 'but', 'endassuming', 'importing', 'orelse', 'with', 'by', 'endcases', 'in', 'postulate', 'xor', 'cases', 'endcond', 'inductive', 'proposition', 'challenge', 'endif', 'judgement', 'recursive', 'claim', 'endtable', 'lambda', 'sublemma', 'closure', 'exists', 'law', 'subtypes', 'cond', 'exporting', 'lemma', 'subtype_of', )

PVS_OPERATORS = ("#", "*", ":)", "=>", "\\/", "/=", "|=", "##", "**", "::", ">", "|>", "#)", "+", ":=", ">=", "]|", "|[", "#]", "++", ";", ">>", "^", "|]", "%", ",", "<", ">>=", "^^", "||", "&", "-", "<<", "@", "`", "|}", "&&", "->", "<<=", "@@", ".", "<=", "{|", "~", "(#", "/", "<=>", "[#", "{||}", "(:", "//", "<>", "[]", "|","(|", "<|", "[|", "|)","(||)", "/\\", "=", "[||]", "|-", ":", "==", "\\", "|->",)
