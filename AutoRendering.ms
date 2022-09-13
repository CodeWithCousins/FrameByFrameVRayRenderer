struct RenderData
(
	frameNum,
	fileName,
	fileExt,
	resolution,
	
	fn SetResolution r =
	(
		local res = FilterString (toLower r) "x"
		this.resolution =[res[1] as float, res[2] as float]
	)
)

struct AutoRenderingFuncs
(
	fn DoRender renData outputDir  = 
	(
		Format "---------------Rendering a frame---------------\n"

		-- Create a dir if not exists in local
		if (not (DoesDirectoryExist outputDir)) do
		(
			Format "Render output dir doesn't exists. Creating dir: [%] \n" outputDir
			local success = MakeDir outputDir
			if (not success) do
			(
				throw ("Unable to create dir [" + outputDIr + "]")
			)
		)

		-- If Render scene dialog is opened, just close it, otherwise some of the settings won't update
		if (RenderSceneDialog.isOpen()) do
		(
			RenderSceneDialog.Close()
		)

		-- Setup Vray RendererClass
		local vrayRenderer = renderers.current

		-- Forcing to render the active viewport
		rendUseActiveView = true

		-- Set the timeline frame
		SliderTime = renData.frameNum

		if (renderRes != unsupplied) do
		(
			renderWidth = renData.resolution.x
			renderHeight = renData.resolution.y
		)

		-- Render Single Frame
		
		rendTimeType = 1

		-- Enable Save File
		rendSaveFile = true

		local renderFilePath = PathConfig.AppendPath outputDir (renData.fileName + "." + renData.fileExt)

		-- Set the output file name
		rendOutputFilename = renderFilePath

		vrayRenderer.output_saveFile = true
		vrayRenderer.output_fileName = renderFilePath

		vrayRenderer.output_saveRawFile = true
		vrayRenderer.output_rawFileName = renderFilePath

		vrayRenderer.output_getsetsfrommax = true

		vrayRenderer.output_on = true

		Render()

		return OK
	),

	fn ReadCsvAndRenderData csvFilePath =
	(
		local renderDataArray =#()
		local fs = OpenFile csvFilePath
		
		while not eof fs do
		(
			local fileLine = readLine fs 
			local filteredLiner = FilterString fileLine ","
			
			local dat = RenderData()
			local ind = VrayRenderSettings()
			dat.frameNum =filteredLiner[1] as integer
			dat.fileName =filteredLiner[2]
			dat.fileExt = filteredLiner[3]
			dat.SetResolution filteredLiner[4]
			ind.GetIndexRenderMask filteredLiner[5]
			Append renderDataArray dat
		)
		Close fs
		
		return renderDataArray
	)
)

struct VrayRenderSettings
(
	renderMaskSettings =#("None","Texture","Selected","Include/Exclude list","Layers","Object IDs"),
	fn GetIndexRenderMask vRayIndex =
	(
		local index = findItem this.renderMaskSettings vRayIndex
		return index
	)
)

