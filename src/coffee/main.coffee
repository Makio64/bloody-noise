#---------------------------------------------------------- Global var

main = null

#---------------------------------------------------------- Class Main

class Main

	dt 				: 0
	lastTime 		: 0
	pause 			: false

	constructor:()->
		@pause = false
		@lastTime = Date.now()
		window.focus()

		Stage2d.init()
		
		graphics = new PIXI.Graphics()
		graphics.beginFill(0xFF0000)
		graphics.drawRect(0,0,window.innerWidth, window.innerHeight)
		graphics.endFill()

		container = new PIXI.DisplayObjectContainer()
		container.addChild(graphics)
		@perlinFilter = new PIXI.PerlinNoiseFilter()
		@perlinFilter.intensity = .5
		@noiseFilter = new PIXI.NoiseFilter()
		@noiseFilter.intensity = .5
		graphics.filters = [@perlinFilter,@noiseFilter]
		Stage2d.stage.addChild(container)

		requestAnimationFrame( @update )
		return

	update:()=>
		t = Date.now()
		dt = t - @lastTime
		@lastTime = t

		if @pause then return

		#update logic here
		mouse = Stage2d.stage.getMousePosition()
		vx = -mouse.x/window.innerWidth+.5
		vy = mouse.y/window.innerHeight-.5

		@perlinFilter.zoom += (.5+Math.sqrt(vx*vx+vy*vy)*4-@perlinFilter.zoom)*0.05

		@noiseFilter.time += 0.01

		speed = 1/@perlinFilter.zoom*.2
		@perlinFilter.position.x += vx*speed;
		@perlinFilter.position.y += vy*speed;

		
		# rendering
		Stage2d.render()

		requestAnimationFrame( @update )
		return

	resize:()=>
		Stage2d.resize()
		return


#---------------------------------------------------------- on Document Ready

document.addEventListener('DOMContentLoaded', ()->
	main = new Main()
	
	window.onblur = (e)->
		main.pause = true
		cancelAnimationFrame(main.update)
		return

	window.onfocus = ()->
		requestAnimationFrame(main.update)
		main.lastTime = Date.now()
		main.pause = false
		return

	window.onresize = ()->
		main.resize()
		return

	return
)