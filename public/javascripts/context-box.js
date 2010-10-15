/*
* ContextBox
* Initialise with:
* button, content, options
* button => The thing that will trigger this context box being opened
* content => The element that should fill this context box
* options => A hash of options
*
* This will open a context box when the button's "onclick" event fires.
* This box will exist in the top of the body tag, unless otherwise specified.
* Automatically decides a side. Will by default look like this:
* <div class="contextbox contextbox_right">
*   <div class="contextbox_arrow contextbox_arrow_left"></div>
*   <yourcontent>
* </div>
* (contextbox_right means the contextbox has opened right. contextbox_arrow_left is the side of the box the arrow is on)
*
* Available Options:
* inside => Element. The element to insert within.
* class => String. The class to use. Default => "contextbox". Can also use "classname".
* arrowClass => String. The class suffix to use for the arrow. Default => "_arrow"
* leftClass => String. The class suffix to use when opening left. Default => "_left".
* topClass => String. The class suffix to use when opening top. Default => "_top".
* rightClass => String. The class suffix to use when opening right. Default => "_right".
* bottomClass => String. The class suffix to use when opening bottom. Default => "_bottom".
* style => Hash. The style to apply to the box. Defaults to {position: absolute, opacity: 0}.
* arrowStyle => Hash. The style to apply to the arrow. Defaults to {position: relative}.
* direction => String. Force a direction (one of top, left, bottom, right)
* arrowPosition => String. Depends on direction (one of top, left, bottom, right)
* buttonDistance => Number. Distance from the button to position the arrow. Default => 20.
* directions => Array. Allow only specific directions, in preferenced order (top, left, bottom, right)
* directionDifference => Number. Choose a direction with larger gap only if gap greater than this difference
* animate => Hash. Choose animation options. Either a straight hash or {out: {options}, in: {options}} (Scripty2 style)
* modal => Boolean (defaults null). If modal will show an overlay with contextbox_overlay class.
* overlayClass => String. The class suffix to use for the overlay.
* overlayAnimate => Hash. Same as animate above.
* highlight => Element. Will give this element the contextbox_highlight class.
* highlightClass => String. The class suffix to use for the highlight. 
*/
var ContextBox = Class.create({
  initialize: function(button, content, options){
    options = $H(options);
    this.button = $(button);
    this.button.contextbox = this;
    this.content = $(content).remove();
    
    this.insideElement = options.get('inside') || $$('body').first();
    
    this.forceDirection = options.get('direction');
    if(this.forceDirection){
      this.arrowPosition = options.get('arrowPosition');
    }
    if(this.forceDirection){
      this.directions = $A([this.forceDirection]);
    }
    else{
      this.directions = $A(options.get('directions') || ['bottom','right','left','top']);
    }
    
    this.directionDifference = options.get('directionDifference') || 50;
    
    this.buttonDistance = options.get('buttonDistance') || 20;
    
    this.animationOptions = options.get('animate') || {
      'out': {
        duration: 0.3,
        transition: 'easeOutBack'
      },
      'in': {
        duration: 0.5,
        transition: 'easeInBack'
      }
    };
    
    this.contextboxStyle = options.get('style') || {
      position: 'absolute',
      opacity: 0
    };
    
    this.arrowStyle = options.get('arrowStyle') || {
      position: 'absolute'
    };
    
    this.contextboxClass = options.get('class') || options.get('classname') || 'contextbox';
    this.arrowClass = options.get('arrowClass') || '_arrow';
    this.modal = options.get('modal');
    if(this.modal){
      this.overlayClass = options.get('overlayClass') || '_overlay';
      this.overlayElement = new Element('div', {
        'class': this.contextboxClass + this.overlayClass,
        'style': 'position: fixed; opacity: 0; display: none'
        });
      this.overlayAnimationOptions = options.get('overlayAnimate') || {
        'out': {
          delay: 0.3,
          duration: 0.5,
          transition: 'easeOutExpo'
        },
        'in': {
          duration: 0.3,
          transition: 'easeInExpo'
        }
      }
    }
    this.highlightElement = options.get('highlight');
    if(this.highlightElement){
      this.highlightElement = $(this.highlightElement);
      this.highlightClass = options.get('highlightClass') || '_highlight';
    }
    this.leftClass = options.get('leftClass') || '_left';
    this.topClass = options.get('topClass') || '_top';
    this.rightClass = options.get('rightClass') || '_right';
    this.bottomClass = options.get('bottomClass') || '_bottom';
    
    this.element = new Element('div', {
      'class': this.contextboxClass
    });
    this.arrowElement = new Element('div', {
      'class': this.contextboxClass + this.arrowClass
    });
    
    
    
    this.element.insert(this.arrowElement);
    this.element.insert({bottom: this.content});
    
    //this.element.insert({bottom: this.content});
    this.element.setStyle(this.contextboxStyle);
    this.arrowElement.setStyle(this.arrowStyle);
    
    this.state = 'closed';
    
    this.button_observer = (this.openEvent).bindAsEventListener(this);
    
    this.button.observe('click', this.button_observer);
    this.closeFunc = (this.closeEvent).bindAsEventListener(this);
    
    this.direction = null;
  },
  destroy: function(){
    this.button.stopObserving('click', this.button_observer);
  },
  open: function(){
    if(this.state == 'open'){
      return;
    }
    this.state = 'open';
    
    this.element.setStyle(this.contextboxStyle);

    
    this.insideElement.insert({top:this.element});
    
    
    
    /* James' Facebook Hack */
    this.element.insert({top:this.elementInner});
    this.element.insert({top:this.elementHeading});        
        
        
    var dimensions = this.element.getDimensions();
    
    var arrowDimensions = this.arrowElement.getDimensions();
    
    var originDimensions = this.button.getDimensions();
    var originCenter = this.button.cumulativeOffset();
    originCenter.left += originDimensions.width/2;
    originCenter.top += originDimensions.height/2;
    
    var viewportDimensions = document.viewport.getDimensions();
    var viewportOffset = document.viewport.getScrollOffsets();
    
    var parent = this.element.getOffsetParent().cumulativeOffset();
    
    var direction = {
      distance: 0
    }
    
    /*
    * OH GOD THE PAIN... 100 LINES OF PURE HATRED
    * TODO: halp? *explode*
    */
    this.directions.each((function(dir){
      if(dir == 'top'){
        var distanceTop = originCenter.top - viewportOffset.top;
        if(distanceTop > (direction.distance + this.directionDifference) || direction.distance == 0){
          var left = originCenter.left - (dimensions.width/2);
          var top = originCenter.top - (originDimensions.height/2) - dimensions.height - arrowDimensions.height;
          direction = {
            distance: distanceTop,
            start: {
              left: left,
              top: top
            },
            end: {
              left: left,
              top: top - this.buttonDistance
            },
            arrow:{
              left: dimensions.width/2 - (arrowDimensions.width/2),
              top: dimensions.height
            },
            contextboxClass: this.contextboxClass + this.topClass,
            arrowClass: this.contextboxClass + this.arrowClass + this.bottomClass
          }
        }
      }
      else if(dir == 'right'){
        var distanceRight = viewportOffset.left + viewportDimensions.width - originCenter.left;
        if(distanceRight > (direction.distance + this.directionDifference) || direction.distance == 0){
          var left = originCenter.left + (originDimensions.width/2) + arrowDimensions.width;
          var top = originCenter.top - (dimensions.height/2);
          direction = {
            distance: distanceRight,
            start: {
              left: left,
              top: top
            },
            end: {
              left: left + this.buttonDistance,
              top: top
            },
            arrow:{
              left: -1*arrowDimensions.width,
              top: dimensions.height/2 - (arrowDimensions.width/2)
            },
            contextboxClass: this.contextboxClass + this.rightClass,
            arrowClass: this.contextboxClass + this.arrowClass + this.leftClass
          }
        }
      }
      else if(dir == 'left'){
        var distanceLeft = originCenter.left - viewportOffset.left;
        if(distanceLeft > (direction.distance + this.directionDifference) || direction.distance == 0){
          var left = originCenter.left - (originDimensions.width/2) - dimensions.width - arrowDimensions.width;
          var top = originCenter.top - (dimensions.height/2);
          direction = {
            distance: distanceLeft,
            start: {
              left: left,
              top: top
            },
            end: {
              left: left - this.buttonDistance,
              top: top
            },
            arrow:{
              left: dimensions.width,
              top: dimensions.height/2 - (arrowDimensions.width/2)
            },
            contextboxClass: this.contextboxClass + this.leftClass,
            arrowClass: this.contextboxClass + this.arrowClass + this.rightClass
          }
        }
      }
      else if(dir == 'bottom'){
        var distanceBottom = viewportOffset.top + viewportDimensions.height + originCenter.top;
        if(distanceBottom > (direction.distance + this.directionDifference) || direction.distance == 0){
          var left = originCenter.left - (dimensions.width/2) - parent.left;
          var top = originCenter.top + (originDimensions.height/2) + arrowDimensions.height - parent.top;
          direction = {
            distance: distanceTop,
            start: {
              left: left,
              top: top
            },
            end: {
              left: left,
              top: top + this.buttonDistance
            },
            arrow:{
              left: dimensions.width/2 - (arrowDimensions.width/2),
              top: -1*arrowDimensions.height
            },
            contextboxClass: this.contextboxClass + this.bottomClass,
            arrowClass: this.contextboxClass + this.arrowClass + this.topClass
          }
        }
      }
    }).bind(this));
    
    this.element.setStyle({
      left: direction.start.left + "px",
      top: direction.start.top + "px",
      display: ''
    });
    
    this.arrowElement.setStyle({
      left: direction.arrow.left + 'px',
      top: direction.arrow.top + 'px'
    })
    
    this.element.addClassName(direction.contextboxClass);
    this.arrowElement.addClassName(direction.arrowClass);
    
    if(this.highlightElement){
      this.highlightElement.addClassName(this.contextboxClass + this.highlightClass);
    }
    
    if(this.modal){
      this.overlayElement.setStyle({
        display: 'none'
      })
      $$('body').first.insert(this.overlayElement);
      var overlay_animation_option = null;
      if(this.overlayAnimationOptions.out){
        overlay_animation_option = Object.clone(this.overlayAnimationOptions.out);
      }
      else{
        overlay_animation_option = Object.clone(this.overlayAnimationOptions);
      }
      this.overlayElement.morph({
        opacity: 1
        },overlay_animation_option);
    }
    
    var animation_option = null;
    if(this.animationOptions.out){
      animation_option = Object.clone(this.animationOptions.out);
    }
    else{
      animation_option = Object.clone(this.animationOptions);
    }
    
    this.element.morph({
      left: direction.end.left + "px",
      top: direction.end.top + "px",
      opacity: 1
    },animation_option);
    
    this.contextboxDirection = direction;
  },
  close: function(){
    if(this.state == 'closed'){
      return;
    }
    this.state = 'closed';
    
    var direction = this.contextboxDirection;
    
    var animation_option = null;
    if(this.animationOptions['in']){
      animation_option = this.animationOptions['in'];
    }
    else{
      animation_option = this.animationOptions;
    }
    
    animation_option.after = (function(){
      this.element.removeClassName(direction.contextboxClass);
      this.arrowElement.removeClassName(direction.arrowClass);
      if(this.highlightElement){
        this.highlightElement.removeClassName(this.contextboxClass + this.highlightClass);
      }
      this.element.remove();
    }).bind(this);
    
    this.element.morph({
      left: direction.start.left + "px",
      top: direction.start.top + "px",
      opacity: 0
    },animation_option);
    
    if(this.modal){
      var overlay_animation_option = null;
      if(this.overlayAnimationOptions['in']){
        overlay_animation_option = this.overlayAnimationOptions['in'];
      }
      else{
        overlay_animation_option = this.overlayAnimationOptions;
      }
      overlay_animation_option.after = (function(){
        this.overlayElement.remove();
      }).bind(this)
      
      this.overlayElement.morph({
        opacity: 0
      },overlay_animation)
    }
  },
  openEvent: function(event){
    if(this.state == 'open'){
      this.closeEvent(event);
      return;
    }
    event.stop();
    this.open();
    
    $$('body').first().observe('click', this.closeFunc);
  },
  closeEvent: function(event){
    if(this.state == 'closed'){
      return;
    }
    var el = $(event.element());
    if(el && el.descendantOf(this.content)){
      return;
    }
    event.stop();
    $$('body').first().stopObserving('click', this.closeFunc);
    
    this.close();
  }
});

var ContextBoxer = {
  opensContextBox: function(element, box, options) {	 
    return new ContextBox(element, box, options);
  }
}

Element.addMethods(ContextBoxer);