#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(DrawViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(color, NSString)
RCT_EXTERN_METHOD(reset:(nonnull NSNumber *)node)
RCT_EXTERN_METHOD(save:(nonnull NSNumber *)node)
RCT_EXPORT_VIEW_PROPERTY(onSaved, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onError, RCTDirectEventBlock)

@end
