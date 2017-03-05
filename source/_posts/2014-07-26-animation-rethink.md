title: Rethink declarative animation
---

## Introduction

Today, beacuse of new trends like [material design](http://www.google.com/design/spec/material-design/introduction.html) and motion design, the animation is become more and more important in web-development.

On the other hand, thanks for the standardized [web-component]() and frameworks like angularjs, knockoutjs, reactjs and vuejs etc.  building the view of application in declartive way is coming into popular .

> __So, what about declarative animation? __


This article serves to demonstrate an even better solution for declarative animation. before diving into detail, let's first check 'Real World  Declartive Animation' .

<!-- more -->

## Real World  Declartive Animation

This section will introduce the exsited approaches to implement declarative animation



### Angular 

[angular](https://github.com/angular/angular.js) is the most popular framework that have nearly 27000 stars on github now. 

in angularjs,  animation support is based on the module `ngAnimate` . The directives that support animation automatically are: ngRepeat, ngInclude, ngIf, ngSwitch, ngShow, ngHide, ngView and ngClass.

you need to define the appropriate CSS classes or to register a JavaScript animation via the module.animation() function.



__Example__

```html
<style type="text/css">
.slide.ng-enter, .slide.ng-leave {
  -webkit-transition:0.5s linear all;
  transition:0.5s linear all;
}

.slide.ng-enter { }        /* starting animations for enter */
.slide.ng-enter-active { } /* terminal animations for enter */
.slide.ng-leave { }        /* starting animations for leave */
.slide.ng-leave-active { } /* terminal animations for leave */
</style>

<!--
the animate service will automatically add .ng-enter and .ng-leave to the element
to trigger the CSS transition/animations
-->
<div class="slide" ng-if="Expression"></div>
```

when the `Expression` is evaluated to `true`, the  class`ng-enter` is added first to  prepares initial state, then `ng-enter-active` is added at nextReflow(similar with `setTimeout(0)`). 


### [Anijs](https://github.com/anijs/anijs)

> Anijs: Declarative handling library for CSS animations. 

anijs's main objective is to provide an eloquent, easy to translate, and quick to develop environment based on css animations.

__Example__

```html
<div id="main" data-anijs="if: DOMContentLoaded, on: document, do: swing animated, after: holdAnimClass"></div>
```

the exmpale above means: 

when  `DOMContentLoaded`  triggered on document, addClass `swing` `animated`, then hold them after animationend(or transitionend). 

It is dead simple and intuitive. the only requirement is to include a 8kb jsfile(minified, no gzip).



### [Vuejs](http://vuejs.org/)

vuejs's animation-support is very lightweight. just like angular, it hooks the element's lifecycle at `enter` and `leave`  (based on directive, e.g. `v-if`). you can use three directive to customize your animation

1. `v-animation`  animation based on class and animation
2. `v-transition`: animation based on class and transition 
3. `v-effect`: custom animation extension.

__example__
use `animation` or `transition`

```html
<p class="animated" v-if="show" v-animation>Look at me!</p>
<p class="msg" v-if="show" v-transition>Hello!</p>

```
use custom effect

```html
<p v-effect="my-effect"></p>
```

```javascript
Vue.effect('my-effect', {
    enter: function (el, insert, timeout) {
        // insert() will actually insert the element
    },
    leave: function (el, remove, timeout) {
        // remove() will actually remove the element
    }
})
```

To be honest, I don't know why vuejs make distinguish between these three cases.

### [React](http://facebook.github.io/react/)

React's animation support is based on the low-level API: `ReactTransitionGroup`. you can check the introduction of `ReactCSSTransitionGroup`(High-level API) on its [animation page](http://facebook.github.io/react/docs/animation.html#getting-started)

__Example__
```
/** @jsx React.DOM */

var ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

var TodoList = React.createClass({
  // ignored some methods for short
  render: function() {
    var items = this.state.items.map(function(item, i) {
      return (
        <div key={item} onClick={this.handleRemove.bind(this, i)}>
          {item}
        </div>
      );
    }.bind(this));
    return (
      <div>
        <button onClick={this.handleAdd}>Add Item</button>
        <ReactCSSTransitionGroup transitionName="example">
          {items}
        </ReactCSSTransitionGroup>
      </div>
    );
  }
});
```

The element that wrapped by  `ReactCSSTransitionGroup` can animate when it is injected to or leave from the component.  it will get the `example-enter` CSS class and the `example-enter-active` CSS class added in the next tick (similar with angular). This is a convention based on the transitionName prop.



### Summary

compare with the `JavaScript-Based Animation`(e.g.  [Velocity.js](http://velocityjs.org/) or jquery), the `declarative animation` that introduced above is obviously less flexible. for example:

1. only works in given environment .(e.g. when element `enter` or `leave`)
2. can not chainable
3. can not combine with other elements's  animation
4. developer know nothing about the phase of the animation. (image that you need do some work in javascript when the animation is done)


## An Even Better Solution for declarative animation!


The solution  introduced later that has been implemented in [regularjs](https://github.com/regularjs/regular) yet. and it can be full-supported by any framework that is data-driven(e.g. angularjs, vuejs, ractivejs..).

the solution is based on single directive: `r-animation`. 

Syntax

```

<div r-animation="Sequence"></div>

Sequence:
  Command (";" Command)*

Command:
  CommandName":" Param

CommandName: [-\w]+

Param: [^;]+


```

The following sections will raise several questions and solve them later by `r-animation`. 

> __please be a patience man until compelete the rest of the page, you will find the power of `r-animation` !__

_the examples will depend on awesome [animate.css](daneden.github.io/animate.css) for some css-related animation._ 


### Question 1: When the animation start

There are two types of Command: 1. `trigger`   2. `step`. 

`trigger` is used to trigger a animation sequence. and `step` is used to define a single animation.

__Command on__ (trigger): when specified event is triggered , starting the animation.

```html
<div r-animation="on: click; class:  animated swing;"> </div>
```

this example means: 
    
1. when the element is clicked, trigged the animations.
2. Command `class` will addclass `animated swing`(maybe trigger animation) to element, when  the `animationend`(or `transitionend`) triggered, remove the class.
3. animation done




#### however, how to hook the `enter` and `leave` time on element?

regularjs emit the mock `enter` and `leave` event for hooking the element's lifycle, you can also use `on` to handle it;

```html

<div class='box' r-hide={{test}} r-animation="
  on: enter; class: animated bounceIn;
  on: leave; class: animated bounceOut">
  Box: enter
</div>

```


it is valid that defining multiply `trigger` on single `r-animation`. every `trigger` will create new animtion sequence.



#### Is there any other trigger? 

now , we can take advantage of the data-driven framework to implement a more flexible command than `on` .

__Command when__ (trigger): when the specifed Expression is evaluated to true, starting the animation.


```html
<div class='box box-2'  r-animation="when: test === true; class: animated swing">
Box2: triggered when test === true
</div>

```

when the `test === true` is computed to true, the animation will start.


> <a href="http://codepen.io/leeluolee/pen/gkcKl/"><span class="icon-arrow-right"> <strong>Result on Codepen</span></strong></a>



### Question 2: How to make the animation chainable?

`r-animation` is born to support chainable animation,you can simply sepecify multiply `steps` after one `trigger`.

__Example__


```html
<div class='box' r-animation=
   "on:click; 
      class: animated swing;
      class: animated shake;
      class: animated bounceOut;
      class: animated bounceIn;
        ">
  click me
</div>


```

now, you will see the steps animate one by one.

> <a href="http://codepen.io/leeluolee/pen/kCqzJ/"><span class="icon-arrow-right"> <strong>Result on Codepen</span></strong></a>



### Question 3: How to animation two element step by step?

Thanks for the data-driven system. you can use the `call` command for evaluating a Expression. after evaluating, the digest phase(regularjs is also based on __dirty-check__) will be automately triggered, it can trigger other animation (work with `when`). 

__Command call__: evaluted a Expression, then enter the component's digest phase. finaly step to next animation.

__Example__

```html

<div class='box animated' r-animation=
     "when:test; 
        class: swing ;
        call: otherSwing=true ;
        class: shake">
  box1: trigger by checkbox
</div>
  
<div class='box animated' r-animation=
     "when: otherSwing; 
        class:  swing; 
      ">box2: after box1 swing</div>

```

steps as follow:

1. when `test` is computed to true, start box1's animation
2. swing then call `otherSwing = true`;
3. box2's `otherSwing` is evaluted to `true`. 
4. box2 shakes, meanwhile box1 shakes;
5. done.

> <a href="http://codepen.io/leeluolee/pen/aHwoh/"><span class="icon-arrow-right"> <strong>Result on Codepen</span></strong></a>


thanks for `call` and data-driven system, we can staying competitive with `javascript based animation` on control.


### Question 4: Is there any other buildin command?

- `wait`: delay for next animation
  
  __example__
  ```html
  <div class='box animated' r-animation=
       "on:click; 
          class: swing ;
          wait: 2000 ;
          class: shake">
    wait: click me
  </div>
  ```
  the example means: after clicking, swing then waiting 2000ms, finally shake.


- `style`: set style and waiting the `transitionend` (if the style trigger the `transition`)
  
  __example__

  ```html
  <div class='box animated' r-animation=
       "on: click; 
          class:  swing; 
          style: color #333;
          class: bounceOut;
          style: display none;
        ">style: click me </div>
  ```

  add `transition` to make color fading effect work.

  ```css
  .box.animated{
     transition:  color 1s linear;
  }
  ```

  example means: after clicking, swing then set `style.color=#333`(trigger transition)... 


> <a href="http://codepen.io/leeluolee/pen/FhwGC/"><span class="icon-arrow-right"> <strong>Result on Codepen</span></strong></a>


you can also extend custom command by your self. 


### Question 5: How to extend Custom Command? 

you can extend javascript-based Animation via  `Component.animation(name, handle)`. 

for example, we need fading animation.

```javascript
Regular.animation("fade", function(step){
  var param = step.param,
    element = step.element,
    fadein = param === "in",
    step = fadein?  1.05: 0.9;
  return function(done){ 
    var start = fadein?  0.01: 1;
    var tid = setInterval(function(){
      start *= step 
      if(fadein && 1- start < 1e-3){
        start = 1; 
        clearInterval(tid);
        done()
      }else if(!fadein && start < 1e-3){
        start = 0;
        clearInterval(tid);
        done()
      }
      element.style.opacity = start;
    }, 1000 / 60) 
  }
})
```

describe in template

```html
<div class='box animated' r-animation=
       "on:click; 
        class: swing ;
        fade: out ;
        fade: in;
         ">
    fade: click me
</div>

```

the only thing you need to do is that: when your animation is compelete, call the function `done`.


> <a href="http://codepen.io/leeluolee/pen/qJvry/"><span class="icon-arrow-right"> <strong>Result on Codepen</span></strong></a>




you can also check the builtin's sourcecode on [github](https://github.com/regularjs/regular/blob/master/src/directive/animation.js#L71). it is realy dead simple!



### Question 6: Need An compeletely Example? 

let's create a infinite animation for joke.

```html
<div class='box animated' r-animation=
      "when:test==1; 
         class: shake;
         call: test=2 ;"
         >
   shake
 </div>

<div class='box animated' r-animation=
    "when: test==2; 
       class:  bounce; 
       call: test=3;
     ">box2: bounce</div>
 
<div class='box animated' r-animation=
  "when: test==3; 
     class:  swing; 
     call: test=1;
   ">box2: swing</div>

```

just as the logic described by the template. the sequence will never stopped.



> <a href="http://codepen.io/leeluolee/pen/vrgqu/"><span class="icon-arrow-right"> <strong>Result on Codepen</span></strong></a>


## End



> ### if the post is helpful to you,  [gives regularjs a star](https://github.com/regularjs/regular)





