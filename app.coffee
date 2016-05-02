# Sketch Import
sketch = Framer.Importer.load "imported/Scrollable"

# Wrap the content within a ScrollComponent
scroll = ScrollComponent.wrap(sketch.content)
scroll.scrollHorizontal = false
scroll.contentInset = 
	bottom: 32

# arrays
images = []
content = [sketch.navBar, scroll]

for name, layer of sketch
	if name.match(/img./i)
		images.push layer

# event for images
for image in images
	image.borderRadius = 6
	image.onClick (event, layer) ->
		
		# unless we're scrolling
		if not scroll.isMoving
		
			# copy image
			currentImage = layer.copy()
			currentImage.placeBehind(sketch.navBar)
			currentImage.frame = layer.screenFrame 
			layer.visible = false
			
			# ignore events and show image
			for image in images
				image.ignoreEvents = true 
			
			# animate the image
			currentImage.animate
				properties:
					midY: Screen.height / 2
					scale: Screen.width / currentImage.width
				curve: "spring(200, 20, 0)"
			
			for layerToHide in content
				layerToHide.animate
					properties:
						opacity: 0
					time: 0.2
			
			# return to default view
			currentImage.onClick (event, layer) ->
				this.animate
					properties:
						scale: 1
						y: layer.screenFrame.y
					time: 0.3
				
				#not working 	
				this.onAnimationEnd (event, layer) ->
					layer.visible = true
					currentImage.destroy()
				
				for layerToShow in content
					layerToShow.animate
						properties:
							opacity: 1
						time: 0.2
				
				# remove ignore events properties
				for image in images
					image.ignoreEvents = false 
			