FileIn "AutoRendering.ms"

try(Destroydialog AutoRendering) catch()

rollout AutoRendering "Auto Rendering"
(
	local AutoRenderingFunc = AutoRenderingFuncs()
	local csvFilePath =""
	local renderOutputDir =""
	
	label lblRenderSettingsPath "  Render Settings File Path:" align:#left
	edittext edtRenderSettingsPath "" align:#left width:240 height:20 across:2
	button btnBrowserRenderSettingsFile "..." align:#right height:20
		
	label lblRenderOutputDir "  Render Output Dir:" align:#left
	edittext edtRenderOutputDir "" align:#left width:240 height:20 across:2
	button btnBrowseRenderOutputDir "..." align:#right height:20
	
	button btnAutoRender "Auto Render" width:290
	
	
	-- FUNCTIONS
	
	-- EVENTS
	on btnBrowserRenderSettingsFile pressed do 
	(
		csvFilePath = GetOpenFileName caption:"Open Render Data File path..." types:"Txt(*.txt)|*.txt|Excel(*.csv)|*.csv|All|*.*|"
		if (csvFilePath != undefined) do edtRenderSettingsPath.text = csvFilePath
	)
	
	on btnBrowseRenderOutputDir pressed do 
	(
		renderOutputDir = GetSavePath caption:"Render Output Dir path..."
		if (renderOutputDir != undefined) do edtRenderOutputDir.text = renderOutputDir 
	)
	
	on btnAutoRender pressed do
	(
		clearListener()
		local renData = AutoRenderingFunc.ReadCsvAndRenderData csvFilePath
		
		-- Render the data 
		--for data in renData do
		--	AutoRenderingFunc.DoRender data dir1
		Messagebox "Scene Rendering Completed"
	)
)

CreateDialog AutoRendering width:300