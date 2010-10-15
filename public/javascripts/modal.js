/*########################################
 *
 * ModalBox
 * Author: MadeByCanvas 2010
 * Requirements: Prototype, scripty2
 *
 * Bender: Hey. What kind of party is this? There's no booze and only one hooker. 
 *
 ########################################*/
 
/* ModalBox constructor function */
function ModalBox(element, box, options) {
  /* grab details from the options object */
  options = $H(options)
  element.modalBox = this;
  this.boxContent = $(box);
  this.element = element;
  this.overlay = $('overlay_shade');

  /* initialise the box */
  this.showing = false;
  this.box = $(document.createElement('div'));
  
  this.box.hide();
  
  this.box.addClassName('modal_wrapper');
  
  this.box.appendChild(this.boxContent);
  this.boxContent.show();
  
  this.load_inside = $(options.get('load_inside') || $$('body').first())

  /* open box animation */
  this.openBox = function() {
    if(this.showing)
      return;
    this.showing = true;
    
    this.load_inside.insert(this.box);
    
    /* calculate the new top and left attributes of the box */
    var documentWidth = document.viewport.getWidth();
    var documentHeight = document.viewport.getHeight();
    
    this.boxContent.setStyle({
      position: 'relative'
    });
    
    var navHeight = $$('header').first().getHeight();
    
    this.box.setStyle({
      display: '',
      left: "0px",
      top: $$('body').first().measure('padding-top') + "px"
    });
    
    this.boxContent.height = this.boxContent.getHeight();
    
    // If browser is awesome
    if (Modernizr.csstransforms && Modernizr.csstransitions) {
      // Offest out of container
      this.boxContent.setStyle({
        WebkitTransform: 'translate(0,-'+(this.boxContent.height+10)+'px) rotateX(-180deg)',
        mozTransform: 'translate(0,-'+(this.boxContent.height+10)+'px) rotateX(-180deg)',
        transform: 'translate(0,-'+(this.boxContent.height+10)+'px) rotateX(-180deg)'
      });
      // If shitty Chrome
      if (Prototype.Browser.Chrome) {
        // Hide shadow
        this.boxContent.style.webkitBoxShadow = 'none';
      }
      // Add animations
      window.setTimeout(function() {
        this.boxContent.addClassName('make_animated');
      }.bind(this), 0);
      // Animate down
      window.setTimeout(function() {
        this.boxContent.setStyle({
          webkitTransform: 'translate(0,'+navHeight+'px)',
          MozTransform: 'translate(0,'+navHeight+'px)',
          transform: 'translate(0,'+navHeight+'px)'
        });
      }.bind(this), 0);
      // If shitty Chrome
      if (Prototype.Browser.Chrome) {
        window.setTimeout(function() {
          // Put shadow back
          this.boxContent.style.webkitBoxShadow = '';
        }.bind(this), 1000);
      }
    } else {  
      this.boxContent.style.top = (this.boxContent.height+10)*-1+'px';
      this.boxContent.morph('top:'+navHeight+'px', {duration: 1, transition: 'webkitCubic'});
    }
    
    // Show overlay shade
    this.overlay.setStyle({
      display: '',
      opacity: 0
    });
    this.overlay.morph('opacity:1', {duration:2});
    
    // Give focus to first field
    this.boxContent.down('input').focus();
    
    /// Grey out primary blue buttons when modal is open
    // 1. Because they're no longer primary buttons.
    // 2. Glowing animations underneath a webkit gradient causes browsers to cook to a fine crisp.
    
    modal_primaries = $$('.modal button.black, .modal .button.black');
    
    $$('.button.black, button.black').each(function(button) {
     if(!modal_primaries.member(button)) {
       button.removeClassName('black');
       button.addClassName('white');
       button.addClassName('formerly_black');
     }
    });
    
    // Tell Prototype stuff has been changed
    document.fire('dom:changed');
    
  }
  
  /* close box animation */
  this.closeBox = function() {
    if(!this.showing)
      return;
    this.showing = false;
		
		var navHeight = $$('header').first().getHeight()-5;
		this.boxContent.height = this.boxContent.getHeight();
		
		if (Modernizr.csstransitions && Modernizr.csstransforms) {  
		  // Slide back
		  this.boxContent.setStyle({
		    webkitTransform: 'translate(0,-'+(this.boxContent.height+10)+'px) rotateX(-180deg)',
		    MozTransform: 'translate(0,-'+(this.boxContent.height+10)+'px) rotateX(-180deg)',
		    transform: 'translate(0,-'+(this.boxContent.height+10)+'px) rotateX(-180deg)'
		  });
		  window.setTimeout( (function() {
		    // Die
		    this.box.remove();
		  }).bind(this), 1300);
		} else {
		  this.box.morph('top:'+(this.boxContent.height+10)*-1 + "px", {
		    duration: 0.5,
		    after: (function(){
		      this.box.setStyle({
		        display: 'none'
		      });
		      this.box.remove();
		    }).bind(this)
		  });
		}
		
		// hide overlay
		this.overlay.morph('opacity:0', {
		  duration: 1,
		  after: ((function(){
		    this.overlay.setStyle({
		      display: 'none'
		    });
		    
		    // reapply primary buttons
		    $$('.formerly_black').each(function(button) {
		      button.removeClassName('formerly_black');
		      button.addClassName('black');
		      button.removeClassName('white');
		    });
		    
		  }).bind(this))
		});
		
  }
  
  
  /* click observer on the element -- opens the box */
  element.observe('click', (function(event) {
    event.stop();
    this.openBox();
  }).bindAsEventListener(this));
  
  this.box.observe('click',(function(event){
    var el = $(event.element());
    if(el && el.descendantOf(this.boxContent)){
      return
    }
    event.stop();
    this.closeBox();
  }).bindAsEventListener(this))
}


var BoxModaler = {
  opensModal: function(element, box, options) {	 
    return new ModalBox(element, box, options);
  },
  
  closesModal: function(element, box){
    element.observe('click', function(event){
      box.closeBox();			
    });
  }
}

Element.addMethods(BoxModaler);
