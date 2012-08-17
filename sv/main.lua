#! /usr/local/bin/luvit

-- youget server

require( "../lumino/lumino" )

local confpath
if #process.argv == 1 then
  confpath = process.argv[1]
end

local conf = mergeJSONs( "./defaults.json", confpath )

http.createServer( function(req,res)
    if httpServeStaticFiles(req,res, conf.documentRoot, nil ) then
      print( "OK URL:", req.url )
      return
    end
    print( "NG URL:", req.url )   
    httpSendRaw( res, 404, "text/plain", "document not found" )
  end):listen( conf.port, "0.0.0.0" )
print("listen on port:", conf.port) 

createCleanPidFile( conf.pidFile )
ignoreSIGPIPE()

process:on("error", function(e)
    print("error handler. e:", e)
  end)