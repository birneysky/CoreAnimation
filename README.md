# Core Animation
ios 主要有两种动画系统：视图动画和Core Animation框架。
### 视图动画
UIView提供了丰富的动画功能，这些功能使用简单并且进行了很好的优化。最常见的动画可以用 +animationWithDuration:animations: 和相关方法处理。你可以使用UIView为frame、bounds、center、transform、alpha，backgroundColor 以及 contentStretch 添加动画效果。
### 图层绘制
CoreAnimation提供了很多工具，有些即便你不打算使用动画也很有用。CoreAnimation中最基础也最重要的部分就是CALayer。CALayer有很多方面都于UIView非常相似。图层会在他的contents属性中绘制任意的东西。你需要负责进行设置，这里有很多方法可用。最简单的一种方法是直接分配。如：
    
    UIImage* image = ......;
    CALayer* layer = ......;
    layer.contents = (id)[image CGImage];
如果你没有直接设置contents属性，Core Animation会按照以下顺序通过CALayer 和委托方法来创建它。

* 1.`[CALayer setNeedsDisplay]`: 你的代码需要调用它。它会将图层标记为需要重绘的，要求通过列表中的步骤来更新contents。除非调用了`setNeedsDisplay` 方法，否则contents属性永远都不会被更新，即便它是nil
* 2.`[CALayer displayIfNeeded:]`:绘图系统会在需要时自动调用它。如果图层被通过调用`setNeedsDispaly`标记为需要重绘的，绘图系统就会接着执行后续步骤
* 3.`[CALayer dispaly]`: `displayIfNeeded`方法会在合适的时候调用它。开发者不应该直接调用它。如何实现了委托方法，默认实现会调用`displayLayer：`委托方法。否则，display方法会调用`drawInContext:`方法。可以在子类中覆盖display方法直接设置contents属性。
* 4.`[deletegate dispalyLayer:]`: 默认的[CALayer display]会在方法实现这个方法是调用它。它的任务是设置contents。如果实现了这个方法（即时没有什么操作），后面就不会运行自定义的绘制代码。
* 5.`[CALayer drawInContext:]`: 默认的`display`方法会创建一个图形上下文并将其传递给`drawInContext:`方法。它与`[UIView drawRect:]`方法相似，但不会自动设置UIKit上下文。为了使用UIkit来绘图，你需要调用`UIGraphicsPushContext()`方法指定接收到的上下文为当前上下文。否则，它只会使用Core Graphics在接收到的上下文中绘图。默认的display方法获取最终的上下文，创建一个CGImage并将其分配给contents。默认的`[CALayer drawInContext:]`会在方法已实现是调用`[delegate drawLayer:inContext:]`。否则就不执行任何操作。
* 6.`[delegate drawLayer:inContext:]`如果实现了这个方法，默认的`drawInContext:`会调用这个方法以更新上下文，从而使`display`方法可以创建CGImage

**综上，有很多方法可以设置图层的内容，可以直接调用`setContents:`方法，也可以通过实现`display`或者`displayLayer:`方法做到，还可以实现`drawInContext:` 或者 `drawLayer: inContext:`方法**

`UIView` 在屏幕上第一次出现时会对自身进行绘制，而`CALayer`则不会。使用`setNeedsDisplay`方法标记 `UIView` 为需要重绘的，这样就可以自动绘制所有子视图了。使用`setNeedsDisplay` 方法标记`CALayer`为需要重绘的则不会对子图层产生影响。**`UIView`默认会在它认为你需要的时候绘制，而`CALayer`默认会在你明确要求时绘制，`CALayer`是底层对象，经过优化，除非开发者明确要求，否则不会浪费时间执行任何操作。**

### 直接设置内容

     #import <QuartzCore/QuartCore.h>
     
     UIImage* image = [UIImage imageNamed:@"pushing"];
     self.view.layer.contentsScale = [[UIScreen mainScreen] scale];
     self.view.layer.contentsGravity = kCAGravityCenter;
     self.view.layer.contents = (id)[image CGImage];

### 实现`display`方法
`display`和`displayLayer:`方法的任务是把`contents`属相设置为合适的`CGImage`。一般覆盖方法的原因是图层有多种状态并且都有各自的图片，按钮通常就是这样的。
到底是创建CALayer的子类还是使用委托这完全是取决于个人爱好和是否方便。UIView包含一个图层，而且它必须是该图层的委托。根据经验，最后不要将UIVIew作为任何子图层的委托。这样做会让UIView在执行某些复制子图层的操作时出现无限死循环。因此你可以在UIView中实现`displayLayer:`方法来管理它的图层，或者将其他对象作为子图层的委托。

### 自定义绘图
与UIView类似，可以完全让CALayer实现自定义绘图。一般可以使用`Core Graphics` 来绘制
使用`drawInContext:`方法是直接设置`contents`的另一种方法。它是由`display`调用的。而`display`只有当你通过`setNeedsDispaly`标记图层为需要重绘是被调用。
以下代码展示了实现委托方法`drawLayer:inContext:`

     - (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
         
        UIGraphicsPushContext(ctx);
    
    	[[UIColor redColor] set];
    	UIRectFill(layer.bounds);
    
    	UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    	UIColor* color = [UIColor blackColor];
    
    
    	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    	[style setAlignment:NSTextAlignmentCenter];
    
    	NSDictionary* atrribs = @{NSFontAttributeName: font,
                              	  NSForegroundColorAttributeName: color,
                                 NSParagraphStyleAttributeName: style};
    
    	NSAttributedString* text = 
    		[[NSAttributedString alloc] initWithString:@"Push the Limits" attributes:atrribs];
    
    	[text drawInRect:CGRectInset(layer.bounds, 10, 20)];
    
    	UIGraphicsPopContext();
     }
     
     
  