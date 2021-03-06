const c = @import("c.zig");
pub usingnamespace c;

pub const XID = c_ulong;
pub const Mask = c_ulong;
pub const Atom = c_ulong;
pub const VisualID = c_ulong;
pub const Time = c_ulong;
pub const Window = XID;
pub const Drawable = XID;
pub const Font = XID;
pub const Pixmap = XID;
pub const Cursor = XID;
pub const Colormap = XID;
pub const GContext = XID;
pub const KeySym = XID;
pub const KeyCode = u8;
pub const X_PROTOCOL = @as(c_int, 11);
pub const X_PROTOCOL_REVISION = @as(c_int, 0);
pub const _XTYPEDEF_XID = "";
pub const _XTYPEDEF_MASK = "";
pub const _XTYPEDEF_ATOM = "";
pub const _XTYPEDEF_FONT = "";
pub const None = @as(c_long, 0);
pub const ParentRelative = @as(c_long, 1);
pub const CopyFromParent = @as(c_long, 0);
pub const PointerWindow = @as(c_long, 0);
pub const InputFocus = @as(c_long, 1);
pub const PointerRoot = @as(c_long, 1);
pub const AnyPropertyType = @as(c_long, 0);
pub const AnyKey = @as(c_long, 0);
pub const AnyButton = @as(c_long, 0);
pub const AllTemporary = @as(c_long, 0);
pub const CurrentTime = @as(c_long, 0);
pub const NoSymbol = @as(c_long, 0);
pub const NoEventMask = @as(c_long, 0);
pub const KeyPressMask = @as(c_long, 1) << @as(c_int, 0);
pub const KeyReleaseMask = @as(c_long, 1) << @as(c_int, 1);
pub const ButtonPressMask = @as(c_long, 1) << @as(c_int, 2);
pub const ButtonReleaseMask = @as(c_long, 1) << @as(c_int, 3);
pub const EnterWindowMask = @as(c_long, 1) << @as(c_int, 4);
pub const LeaveWindowMask = @as(c_long, 1) << @as(c_int, 5);
pub const PointerMotionMask = @as(c_long, 1) << @as(c_int, 6);
pub const PointerMotionHintMask = @as(c_long, 1) << @as(c_int, 7);
pub const Button1MotionMask = @as(c_long, 1) << @as(c_int, 8);
pub const Button2MotionMask = @as(c_long, 1) << @as(c_int, 9);
pub const Button3MotionMask = @as(c_long, 1) << @as(c_int, 10);
pub const Button4MotionMask = @as(c_long, 1) << @as(c_int, 11);
pub const Button5MotionMask = @as(c_long, 1) << @as(c_int, 12);
pub const ButtonMotionMask = @as(c_long, 1) << @as(c_int, 13);
pub const KeymapStateMask = @as(c_long, 1) << @as(c_int, 14);
pub const ExposureMask = @as(c_long, 1) << @as(c_int, 15);
pub const VisibilityChangeMask = @as(c_long, 1) << @as(c_int, 16);
pub const StructureNotifyMask = @as(c_long, 1) << @as(c_int, 17);
pub const ResizeRedirectMask = @as(c_long, 1) << @as(c_int, 18);
pub const SubstructureNotifyMask = @as(c_long, 1) << @as(c_int, 19);
pub const SubstructureRedirectMask = @as(c_long, 1) << @as(c_int, 20);
pub const FocusChangeMask = @as(c_long, 1) << @as(c_int, 21);
pub const PropertyChangeMask = @as(c_long, 1) << @as(c_int, 22);
pub const ColormapChangeMask = @as(c_long, 1) << @as(c_int, 23);
pub const OwnerGrabButtonMask = @as(c_long, 1) << @as(c_int, 24);
pub const KeyPress = @as(c_int, 2);
pub const KeyRelease = @as(c_int, 3);
pub const ButtonPress = @as(c_int, 4);
pub const ButtonRelease = @as(c_int, 5);
pub const MotionNotify = @as(c_int, 6);
pub const EnterNotify = @as(c_int, 7);
pub const LeaveNotify = @as(c_int, 8);
pub const FocusIn = @as(c_int, 9);
pub const FocusOut = @as(c_int, 10);
pub const KeymapNotify = @as(c_int, 11);
pub const Expose = @as(c_int, 12);
pub const GraphicsExpose = @as(c_int, 13);
pub const NoExpose = @as(c_int, 14);
pub const VisibilityNotify = @as(c_int, 15);
pub const CreateNotify = @as(c_int, 16);
pub const DestroyNotify = @as(c_int, 17);
pub const UnmapNotify = @as(c_int, 18);
pub const MapNotify = @as(c_int, 19);
pub const MapRequest = @as(c_int, 20);
pub const ReparentNotify = @as(c_int, 21);
pub const ConfigureNotify = @as(c_int, 22);
pub const ConfigureRequest = @as(c_int, 23);
pub const GravityNotify = @as(c_int, 24);
pub const ResizeRequest = @as(c_int, 25);
pub const CirculateNotify = @as(c_int, 26);
pub const CirculateRequest = @as(c_int, 27);
pub const PropertyNotify = @as(c_int, 28);
pub const SelectionClear = @as(c_int, 29);
pub const SelectionRequest = @as(c_int, 30);
pub const SelectionNotify = @as(c_int, 31);
pub const ColormapNotify = @as(c_int, 32);
pub const ClientMessage = @as(c_int, 33);
pub const MappingNotify = @as(c_int, 34);
pub const GenericEvent = @as(c_int, 35);
pub const LASTEvent = @as(c_int, 36);
pub const ShiftMask = @as(c_int, 1) << @as(c_int, 0);
pub const LockMask = @as(c_int, 1) << @as(c_int, 1);
pub const ControlMask = @as(c_int, 1) << @as(c_int, 2);
pub const Mod1Mask = @as(c_int, 1) << @as(c_int, 3);
pub const Mod2Mask = @as(c_int, 1) << @as(c_int, 4);
pub const Mod3Mask = @as(c_int, 1) << @as(c_int, 5);
pub const Mod4Mask = @as(c_int, 1) << @as(c_int, 6);
pub const Mod5Mask = @as(c_int, 1) << @as(c_int, 7);
pub const ShiftMapIndex = @as(c_int, 0);
pub const LockMapIndex = @as(c_int, 1);
pub const ControlMapIndex = @as(c_int, 2);
pub const Mod1MapIndex = @as(c_int, 3);
pub const Mod2MapIndex = @as(c_int, 4);
pub const Mod3MapIndex = @as(c_int, 5);
pub const Mod4MapIndex = @as(c_int, 6);
pub const Mod5MapIndex = @as(c_int, 7);
pub const Button1Mask = @as(c_int, 1) << @as(c_int, 8);
pub const Button2Mask = @as(c_int, 1) << @as(c_int, 9);
pub const Button3Mask = @as(c_int, 1) << @as(c_int, 10);
pub const Button4Mask = @as(c_int, 1) << @as(c_int, 11);
pub const Button5Mask = @as(c_int, 1) << @as(c_int, 12);
pub const AnyModifier = @as(c_int, 1) << @as(c_int, 15);
pub const Button1 = @as(c_int, 1);
pub const Button2 = @as(c_int, 2);
pub const Button3 = @as(c_int, 3);
pub const Button4 = @as(c_int, 4);
pub const Button5 = @as(c_int, 5);
pub const NotifyNormal = @as(c_int, 0);
pub const NotifyGrab = @as(c_int, 1);
pub const NotifyUngrab = @as(c_int, 2);
pub const NotifyWhileGrabbed = @as(c_int, 3);
pub const NotifyHint = @as(c_int, 1);
pub const NotifyAncestor = @as(c_int, 0);
pub const NotifyVirtual = @as(c_int, 1);
pub const NotifyInferior = @as(c_int, 2);
pub const NotifyNonlinear = @as(c_int, 3);
pub const NotifyNonlinearVirtual = @as(c_int, 4);
pub const NotifyPointer = @as(c_int, 5);
pub const NotifyPointerRoot = @as(c_int, 6);
pub const NotifyDetailNone = @as(c_int, 7);
pub const VisibilityUnobscured = @as(c_int, 0);
pub const VisibilityPartiallyObscured = @as(c_int, 1);
pub const VisibilityFullyObscured = @as(c_int, 2);
pub const PlaceOnTop = @as(c_int, 0);
pub const PlaceOnBottom = @as(c_int, 1);
pub const FamilyInternet = @as(c_int, 0);
pub const FamilyDECnet = @as(c_int, 1);
pub const FamilyChaos = @as(c_int, 2);
pub const FamilyInternet6 = @as(c_int, 6);
pub const FamilyServerInterpreted = @as(c_int, 5);
pub const PropertyNewValue = @as(c_int, 0);
pub const PropertyDelete = @as(c_int, 1);
pub const ColormapUninstalled = @as(c_int, 0);
pub const ColormapInstalled = @as(c_int, 1);
pub const GrabModeSync = @as(c_int, 0);
pub const GrabModeAsync = @as(c_int, 1);
pub const GrabSuccess = @as(c_int, 0);
pub const AlreadyGrabbed = @as(c_int, 1);
pub const GrabInvalidTime = @as(c_int, 2);
pub const GrabNotViewable = @as(c_int, 3);
pub const GrabFrozen = @as(c_int, 4);
pub const AsyncPointer = @as(c_int, 0);
pub const SyncPointer = @as(c_int, 1);
pub const ReplayPointer = @as(c_int, 2);
pub const AsyncKeyboard = @as(c_int, 3);
pub const SyncKeyboard = @as(c_int, 4);
pub const ReplayKeyboard = @as(c_int, 5);
pub const AsyncBoth = @as(c_int, 6);
pub const SyncBoth = @as(c_int, 7);
pub const RevertToNone = @import("std").zig.c_translation.cast(c_int, None);
pub const RevertToPointerRoot = @import("std").zig.c_translation.cast(c_int, PointerRoot);
pub const RevertToParent = @as(c_int, 2);
pub const Success = @as(c_int, 0);
pub const BadRequest = @as(c_int, 1);
pub const BadValue = @as(c_int, 2);
pub const BadWindow = @as(c_int, 3);
pub const BadPixmap = @as(c_int, 4);
pub const BadAtom = @as(c_int, 5);
pub const BadCursor = @as(c_int, 6);
pub const BadFont = @as(c_int, 7);
pub const BadMatch = @as(c_int, 8);
pub const BadDrawable = @as(c_int, 9);
pub const BadAccess = @as(c_int, 10);
pub const BadAlloc = @as(c_int, 11);
pub const BadColor = @as(c_int, 12);
pub const BadGC = @as(c_int, 13);
pub const BadIDChoice = @as(c_int, 14);
pub const BadName = @as(c_int, 15);
pub const BadLength = @as(c_int, 16);
pub const BadImplementation = @as(c_int, 17);
pub const FirstExtensionError = @as(c_int, 128);
pub const LastExtensionError = @as(c_int, 255);
pub const InputOutput = @as(c_int, 1);
pub const InputOnly = @as(c_int, 2);
pub const CWBackPixmap = @as(c_long, 1) << @as(c_int, 0);
pub const CWBackPixel = @as(c_long, 1) << @as(c_int, 1);
pub const CWBorderPixmap = @as(c_long, 1) << @as(c_int, 2);
pub const CWBorderPixel = @as(c_long, 1) << @as(c_int, 3);
pub const CWBitGravity = @as(c_long, 1) << @as(c_int, 4);
pub const CWWinGravity = @as(c_long, 1) << @as(c_int, 5);
pub const CWBackingStore = @as(c_long, 1) << @as(c_int, 6);
pub const CWBackingPlanes = @as(c_long, 1) << @as(c_int, 7);
pub const CWBackingPixel = @as(c_long, 1) << @as(c_int, 8);
pub const CWOverrideRedirect = @as(c_long, 1) << @as(c_int, 9);
pub const CWSaveUnder = @as(c_long, 1) << @as(c_int, 10);
pub const CWEventMask = @as(c_long, 1) << @as(c_int, 11);
pub const CWDontPropagate = @as(c_long, 1) << @as(c_int, 12);
pub const CWColormap = @as(c_long, 1) << @as(c_int, 13);
pub const CWCursor = @as(c_long, 1) << @as(c_int, 14);
pub const CWX = @as(c_int, 1) << @as(c_int, 0);
pub const CWY = @as(c_int, 1) << @as(c_int, 1);
pub const CWWidth = @as(c_int, 1) << @as(c_int, 2);
pub const CWHeight = @as(c_int, 1) << @as(c_int, 3);
pub const CWBorderWidth = @as(c_int, 1) << @as(c_int, 4);
pub const CWSibling = @as(c_int, 1) << @as(c_int, 5);
pub const CWStackMode = @as(c_int, 1) << @as(c_int, 6);
pub const ForgetGravity = @as(c_int, 0);
pub const NorthWestGravity = @as(c_int, 1);
pub const NorthGravity = @as(c_int, 2);
pub const NorthEastGravity = @as(c_int, 3);
pub const WestGravity = @as(c_int, 4);
pub const CenterGravity = @as(c_int, 5);
pub const EastGravity = @as(c_int, 6);
pub const SouthWestGravity = @as(c_int, 7);
pub const SouthGravity = @as(c_int, 8);
pub const SouthEastGravity = @as(c_int, 9);
pub const StaticGravity = @as(c_int, 10);
pub const UnmapGravity = @as(c_int, 0);
pub const NotUseful = @as(c_int, 0);
pub const WhenMapped = @as(c_int, 1);
pub const Always = @as(c_int, 2);
pub const IsUnmapped = @as(c_int, 0);
pub const IsUnviewable = @as(c_int, 1);
pub const IsViewable = @as(c_int, 2);
pub const SetModeInsert = @as(c_int, 0);
pub const SetModeDelete = @as(c_int, 1);
pub const DestroyAll = @as(c_int, 0);
pub const RetainPermanent = @as(c_int, 1);
pub const RetainTemporary = @as(c_int, 2);
pub const Above = @as(c_int, 0);
pub const Below = @as(c_int, 1);
pub const TopIf = @as(c_int, 2);
pub const BottomIf = @as(c_int, 3);
pub const Opposite = @as(c_int, 4);
pub const RaiseLowest = @as(c_int, 0);
pub const LowerHighest = @as(c_int, 1);
pub const PropModeReplace = @as(c_int, 0);
pub const PropModePrepend = @as(c_int, 1);
pub const PropModeAppend = @as(c_int, 2);
pub const GXclear = @as(c_int, 0x0);
pub const GXand = @as(c_int, 0x1);
pub const GXandReverse = @as(c_int, 0x2);
pub const GXcopy = @as(c_int, 0x3);
pub const GXandInverted = @as(c_int, 0x4);
pub const GXnoop = @as(c_int, 0x5);
pub const GXxor = @as(c_int, 0x6);
pub const GXor = @as(c_int, 0x7);
pub const GXnor = @as(c_int, 0x8);
pub const GXequiv = @as(c_int, 0x9);
pub const GXinvert = @as(c_int, 0xa);
pub const GXorReverse = @as(c_int, 0xb);
pub const GXcopyInverted = @as(c_int, 0xc);
pub const GXorInverted = @as(c_int, 0xd);
pub const GXnand = @as(c_int, 0xe);
pub const GXset = @as(c_int, 0xf);
pub const LineSolid = @as(c_int, 0);
pub const LineOnOffDash = @as(c_int, 1);
pub const LineDoubleDash = @as(c_int, 2);
pub const CapNotLast = @as(c_int, 0);
pub const CapButt = @as(c_int, 1);
pub const CapRound = @as(c_int, 2);
pub const CapProjecting = @as(c_int, 3);
pub const JoinMiter = @as(c_int, 0);
pub const JoinRound = @as(c_int, 1);
pub const JoinBevel = @as(c_int, 2);
pub const FillSolid = @as(c_int, 0);
pub const FillTiled = @as(c_int, 1);
pub const FillStippled = @as(c_int, 2);
pub const FillOpaqueStippled = @as(c_int, 3);
pub const EvenOddRule = @as(c_int, 0);
pub const WindingRule = @as(c_int, 1);
pub const ClipByChildren = @as(c_int, 0);
pub const IncludeInferiors = @as(c_int, 1);
pub const Unsorted = @as(c_int, 0);
pub const YSorted = @as(c_int, 1);
pub const YXSorted = @as(c_int, 2);
pub const YXBanded = @as(c_int, 3);
pub const CoordModeOrigin = @as(c_int, 0);
pub const CoordModePrevious = @as(c_int, 1);
pub const Complex = @as(c_int, 0);
pub const Nonconvex = @as(c_int, 1);
pub const Convex = @as(c_int, 2);
pub const ArcChord = @as(c_int, 0);
pub const ArcPieSlice = @as(c_int, 1);
pub const GCFunction = @as(c_long, 1) << @as(c_int, 0);
pub const GCPlaneMask = @as(c_long, 1) << @as(c_int, 1);
pub const GCForeground = @as(c_long, 1) << @as(c_int, 2);
pub const GCBackground = @as(c_long, 1) << @as(c_int, 3);
pub const GCLineWidth = @as(c_long, 1) << @as(c_int, 4);
pub const GCLineStyle = @as(c_long, 1) << @as(c_int, 5);
pub const GCCapStyle = @as(c_long, 1) << @as(c_int, 6);
pub const GCJoinStyle = @as(c_long, 1) << @as(c_int, 7);
pub const GCFillStyle = @as(c_long, 1) << @as(c_int, 8);
pub const GCFillRule = @as(c_long, 1) << @as(c_int, 9);
pub const GCTile = @as(c_long, 1) << @as(c_int, 10);
pub const GCStipple = @as(c_long, 1) << @as(c_int, 11);
pub const GCTileStipXOrigin = @as(c_long, 1) << @as(c_int, 12);
pub const GCTileStipYOrigin = @as(c_long, 1) << @as(c_int, 13);
pub const GCFont = @as(c_long, 1) << @as(c_int, 14);
pub const GCSubwindowMode = @as(c_long, 1) << @as(c_int, 15);
pub const GCGraphicsExposures = @as(c_long, 1) << @as(c_int, 16);
pub const GCClipXOrigin = @as(c_long, 1) << @as(c_int, 17);
pub const GCClipYOrigin = @as(c_long, 1) << @as(c_int, 18);
pub const GCClipMask = @as(c_long, 1) << @as(c_int, 19);
pub const GCDashOffset = @as(c_long, 1) << @as(c_int, 20);
pub const GCDashList = @as(c_long, 1) << @as(c_int, 21);
pub const GCArcMode = @as(c_long, 1) << @as(c_int, 22);
pub const GCLastBit = @as(c_int, 22);
pub const FontLeftToRight = @as(c_int, 0);
pub const FontRightToLeft = @as(c_int, 1);
pub const FontChange = @as(c_int, 255);
pub const XYBitmap = @as(c_int, 0);
pub const XYPixmap = @as(c_int, 1);
pub const ZPixmap = @as(c_int, 2);
pub const AllocNone = @as(c_int, 0);
pub const AllocAll = @as(c_int, 1);
pub const DoRed = @as(c_int, 1) << @as(c_int, 0);
pub const DoGreen = @as(c_int, 1) << @as(c_int, 1);
pub const DoBlue = @as(c_int, 1) << @as(c_int, 2);
pub const CursorShape = @as(c_int, 0);
pub const TileShape = @as(c_int, 1);
pub const StippleShape = @as(c_int, 2);
pub const AutoRepeatModeOff = @as(c_int, 0);
pub const AutoRepeatModeOn = @as(c_int, 1);
pub const AutoRepeatModeDefault = @as(c_int, 2);
pub const LedModeOff = @as(c_int, 0);
pub const LedModeOn = @as(c_int, 1);
pub const KBKeyClickPercent = @as(c_long, 1) << @as(c_int, 0);
pub const KBBellPercent = @as(c_long, 1) << @as(c_int, 1);
pub const KBBellPitch = @as(c_long, 1) << @as(c_int, 2);
pub const KBBellDuration = @as(c_long, 1) << @as(c_int, 3);
pub const KBLed = @as(c_long, 1) << @as(c_int, 4);
pub const KBLedMode = @as(c_long, 1) << @as(c_int, 5);
pub const KBKey = @as(c_long, 1) << @as(c_int, 6);
pub const KBAutoRepeatMode = @as(c_long, 1) << @as(c_int, 7);
pub const MappingSuccess = @as(c_int, 0);
pub const MappingBusy = @as(c_int, 1);
pub const MappingFailed = @as(c_int, 2);
pub const MappingModifier = @as(c_int, 0);
pub const MappingKeyboard = @as(c_int, 1);
pub const MappingPointer = @as(c_int, 2);
pub const DontPreferBlanking = @as(c_int, 0);
pub const PreferBlanking = @as(c_int, 1);
pub const DefaultBlanking = @as(c_int, 2);
pub const DisableScreenSaver = @as(c_int, 0);
pub const DisableScreenInterval = @as(c_int, 0);
pub const DontAllowExposures = @as(c_int, 0);
pub const AllowExposures = @as(c_int, 1);
pub const DefaultExposures = @as(c_int, 2);
pub const ScreenSaverReset = @as(c_int, 0);
pub const ScreenSaverActive = @as(c_int, 1);
pub const HostInsert = @as(c_int, 0);
pub const HostDelete = @as(c_int, 1);
pub const EnableAccess = @as(c_int, 1);
pub const DisableAccess = @as(c_int, 0);
pub const StaticGray = @as(c_int, 0);
pub const GrayScale = @as(c_int, 1);
pub const StaticColor = @as(c_int, 2);
pub const PseudoColor = @as(c_int, 3);
pub const TrueColor = @as(c_int, 4);
pub const DirectColor = @as(c_int, 5);
pub const LSBFirst = @as(c_int, 0);
pub const MSBFirst = @as(c_int, 1);
