#define GL_SILENCE_DEPRECATION

#import <Cocoa/Cocoa.h>
#import <MetalKit/MetalKit.h>

extern void frame(int, int);

@interface OpenGLView: NSOpenGLView
- (void)requestFrame:(id)sender;
@end

@interface MetalView: MTKView
@end

@interface AppDelegate : NSObject<NSApplicationDelegate>

@property(nonatomic, strong) NSWindow* window;
@property(nonatomic, strong) NSView* view;

+ (id)appDelegateWithWindowWidth:(CGFloat)window_width height:(CGFloat)window_height andTitle:(NSString*)windowTitle;

@end

@implementation AppDelegate

+ (id)appDelegateWithWindowWidth:(CGFloat)window_width height:(CGFloat)window_height andTitle:(NSString*)windowTitle {

    AppDelegate* instance = [AppDelegate new];

    NSRect window_rect = NSMakeRect(0, 0, window_width, window_height);

    instance.window = [[NSWindow alloc]
        initWithContentRect:window_rect
        styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
        backing:NSBackingStoreBuffered
        defer:NO
    ];

    instance.window.releasedWhenClosed = NO;
    instance.window.acceptsMouseMovedEvents = YES;
    instance.window.restorable = YES;

    instance.window.title = [NSString stringWithUTF8String:windowTitle];

    { // opengl
        NSOpenGLPixelFormatAttribute attrs[32];
        int i = 0;
        attrs[i++] = NSOpenGLPFAAccelerated;
        attrs[i++] = NSOpenGLPFADoubleBuffer;
        attrs[i++] = NSOpenGLPFAOpenGLProfile;
        attrs[i++] = NSOpenGLProfileVersion4_1Core;
        attrs[i++] = NSOpenGLPFAColorSize; attrs[i++] = 24;
        attrs[i++] = NSOpenGLPFAAlphaSize; attrs[i++] = 8;
        attrs[i++] = NSOpenGLPFADepthSize; attrs[i++] = 24;
        attrs[i++] = NSOpenGLPFAStencilSize; attrs[i++] = 8;

        // TODO(hazeycode): multisampling
        attrs[i++] = NSOpenGLPFASampleBuffers; attrs[i++] = 0;
        // attrs[i++] = NSOpenGLPFAMultisample;
        // attrs[i++] = NSOpenGLPFASampleBuffers; attrs[i++] = 1;
        // attrs[i++] = NSOpenGLPFASamples; attrs[i++] = (NSOpenGLPixelFormatAttribute)sample_count;
        attrs[i++] = 0;

        NSOpenGLPixelFormat* pixel_format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
        NSAssert(pixel_format != nil, @"Failed to create OpenGL pixel format");

        instance.view = [[OpenGLView alloc]
            initWithFrame:window_rect
            pixelFormat:pixel_format];

        [instance.view updateTrackingAreas];
        [instance.view setWantsBestResolutionOpenGLSurface:YES];

        instance.window.contentView = instance.view;
    }

    return instance;
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification {

    [self.window center];
    [self.window makeFirstResponder:self.view];

    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp activateIgnoringOtherApps:YES];

    [[NSRunLoop currentRunLoop]
        addTimer:[NSTimer timerWithTimeInterval:1/60
            target:self.view
            selector:@selector(requestFrame:)
            userInfo:nil
            repeats:YES]
        forMode:NSDefaultRunLoopMode];

    [self.window makeKeyAndOrderFront:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    // TODO(hazeycode): notify 
}
@end // AppDelegate


@implementation MetalView
@end // MetalView


@implementation OpenGLView

- (void)reshape {
    [super reshape];
}

- (void)requestFrame:(id)sender {
    [self setNeedsDisplay:YES];
}

- (void)prepareOpenGL {
    [super prepareOpenGL];
    GLint swapInt = 1;
    NSOpenGLContext* ctx = [self openGLContext];
    [ctx setValues:&swapInt forParameter:NSOpenGLContextParameterSwapInterval];
    [ctx makeCurrentContext];
}

- (void)drawRect:(NSRect)rect {
    frame(rect.size.width, rect.size.height);
    [[self openGLContext] flushBuffer];
}

- (BOOL)isOpaque {
    return YES;
}

- (BOOL)canBecomeKeyView {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)updateTrackingAreas {

}

@end // OpenGLView
