var Main, main,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

main = null;

Main = (function() {
  Main.prototype.dt = 0;

  Main.prototype.lastTime = 0;

  Main.prototype.pause = false;

  function Main() {
    this.resize = __bind(this.resize, this);
    this.update = __bind(this.update, this);
    var container, graphics;
    this.pause = false;
    this.lastTime = Date.now();
    window.focus();
    Stage2d.init();
    graphics = new PIXI.Graphics();
    graphics.beginFill(0xFF0000);
    graphics.drawRect(0, 0, window.innerWidth, window.innerHeight);
    graphics.endFill();
    container = new PIXI.DisplayObjectContainer();
    container.addChild(graphics);
    this.perlinFilter = new PIXI.PerlinNoiseFilter();
    this.perlinFilter.intensity = .5;
    this.noiseFilter = new PIXI.NoiseFilter();
    this.noiseFilter.intensity = .5;
    graphics.filters = [this.perlinFilter, this.noiseFilter];
    Stage2d.stage.addChild(container);
    requestAnimationFrame(this.update);
    return;
  }

  Main.prototype.update = function() {
    var dt, mouse, speed, t, vx, vy;
    t = Date.now();
    dt = t - this.lastTime;
    this.lastTime = t;
    if (this.pause) {
      return;
    }
    mouse = Stage2d.stage.getMousePosition();
    vx = -mouse.x / window.innerWidth + .5;
    vy = mouse.y / window.innerHeight - .5;
    this.perlinFilter.zoom += (.5 + Math.sqrt(vx * vx + vy * vy) * 4 - this.perlinFilter.zoom) * 0.05;
    this.noiseFilter.time += 0.01;
    speed = 1 / this.perlinFilter.zoom * .2;
    this.perlinFilter.position.x += vx * speed;
    this.perlinFilter.position.y += vy * speed;
    Stage2d.render();
    requestAnimationFrame(this.update);
  };

  Main.prototype.resize = function() {
    Stage2d.resize();
  };

  return Main;

})();

document.addEventListener('DOMContentLoaded', function() {
  main = new Main();
  window.onblur = function(e) {
    main.pause = true;
    cancelAnimationFrame(main.update);
  };
  window.onfocus = function() {
    requestAnimationFrame(main.update);
    main.lastTime = Date.now();
    main.pause = false;
  };
  window.onresize = function() {
    main.resize();
  };
});

//# sourceMappingURL=main.js.map
