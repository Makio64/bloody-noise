class Stage2d

	@stage 		: null
	@renderer	: null

	@init:()->
		@renderer = new PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight)
		@stage = new PIXI.Stage()
		document.body.appendChild( @renderer.view )
		return

	@render:()->
		@renderer.render ( @stage )
		return

	@resize:()->
		@renderer.resize( window.innerWidth, window.innerHeight )
		return