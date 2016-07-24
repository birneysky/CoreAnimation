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
     
     
### 隐式动画
`CALayer`隐式为所有支持动画的属性添加动画，可以使用`【CATransaction setDisableActions:YES】`来关闭默认动画。通常只需要设置图层的属性，图层就会以默认的方式执行动画。`Core Animation`把属性的更改绑定到了原子事务`CATransaction`，当你首次在一个包含运行循环的的线程上修改一个图层时。系统会为你创建一个隐式的`CATransaction`在运行循环中，所有的图层修改都被收集起来，当运行循环结束时，所以得修改都提交到图层树。如果想要修改动画属性，需要对当前事务进行修改。例如动画持续时间`[CATransaction setAnimationDuration:2.0]`  也可以使用`【CATransaction setCompletionBlock:】`设置一个完整的代码块(completion block).**可以使用这种方式连接多个动画，虽然运行循环而已自动创建一个事务，但你还是可以通过`[CATransaction Begin]`和`【CATransaction commit】`来创建自己的显示事务，这样你可以为动画的不同部分指定不同的持续时间或者禁用时间循环中某一部分的动画**



一切没有代码示例的扯淡都是瞎扯淡。
    
    [CATransaction begin];
    //[CATransaction setDisableActions:YES];
    [CATransaction setAnimationDuration:3];
    
    NSArray* layers = self.view.layer.sublayers;
    CALayer* layer = [layers objectAtIndex:2];
    [layer setPosition:CGPointMake(200, 250)];
    
    [CATransaction commit];
    
* 如何为`CALayer`的自定义属性添加动画呢？


### 显示动画
所有在隐式动画里做到的都能在显示动画里做到，最基本的动画是`CABasicAnimation`


    ALayer* squareLayer = [CALayer layer];
    squareLayer.backgroundColor = [[UIColor redColor] CGColor];
    
    squareLayer.frame = CGRectMake(100, 100, 20, 20);
    [self.view.layer addSublayer:squareLayer];
    
    CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fade.duration = 2.0;
    fade.fromValue = @1.0;
    fade.toValue = @0.0;
    [squareLayer addAnimation:fade forKey:@"fade"];
    
 `CABasicAnimation`是一个基本动画，虽然容易使用但是不是很灵活，想要更多的控制动画，可以使用`CAKeyFrameAnimation`。
 
 动画的工作原理是创建图层的多个副本，发送`setValue: forKey:`消息到副本，然后显示。
 上面的示例代码中，有一个麻烦的问题 `闪回` 这段代码会让图层淡出，然后又突然出现。为什么呢？
 这是因为动画在工作时`CABasicAnimation`创建了`CALayer`的副本，并对其修改，这个副本被称为表示层，表示层会被
 绘制到屏幕上，绘制完成后，所有的更改都会丢失，并有模型层决定新的状态(模型层是原本的`CALayer`对象的属性定义的)
 
 上述问题的解决方法是设置模型层 
 
    squareLayer.opacity = 0;
    CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 2.0;
    fade.fromValue = @1.0;
    fade.toValue = @0.0;
    [squareLayer addAnimation:fade forKey:@"fade"];
    
    
 有时候它能正常工作，但是有时`setOpacity:`中的隐式动画会与`animationWithKeyPath:`的显示动画冲突最好的解决办法是在执行显示动画时，先关闭隐式动画。
 
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    squareLayer.opacity = 0;
    CABasicAnimation* fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = 2.0;
    fade.fromValue = @1.0;
    fade.toValue = @0.0;
    [squareLayer addAnimation:fade forKey:@"fade"];
    [CATransaction commit];
    
 
    
    
     @implementation CALayer (ZBAnimation)
     
     - (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
        duration:(CFTimeInterval)duration
           delay:(CFTimeInterval)delay
	{
    	[CATransaction begin];
    
    	[CATransaction setDisableActions:YES];
    
    	//[self setValue:value forKeyPath:keyPath];
    
    	CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:keyPath];
    	anim.duration = duration;
    	anim.beginTime = CACurrentMediaTime() + delay;
    	anim.fillMode = kCAFillModeBoth;
    	anim.fromValue = [self valueForKey:keyPath];
    	//[[self presentationLayer] valueForKey:keyPath];
    	anim.toValue = value;
    	[self addAnimation:anim forKey:keyPath];
    	[self setValue:value forKeyPath:keyPath];
    	[CATransaction commit];
	}

	@end
`presentationLayer` 应该是上文提到的表示层。但是根据实际测试，presentationLayer 方法总是返回nil，具体原因也不清楚，改为`[self valueForKey:keyPath]`