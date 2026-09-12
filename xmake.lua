-- set minimum xmake version
set_xmakever("3.0.0")

includes("lib/commonlibsse-ng")

local PLUGIN_NAME = "PrismaUI-Example-Plugin"
local PLUGIN_VERSION = "1.5.0"

local VIEW_NAME = "PrismaUI-Example-UI"

set_project(PLUGIN_NAME)
set_version(PLUGIN_VERSION)
set_license("GPL-3.0")

set_languages("c++23")
set_warnings("allextra")
add_defines("UNICODE", "_UNICODE")

set_policy("package.requires_lock", true)

add_rules("mode.release")
--add_rules("mode.debug", "mode.releasedbg")
add_rules("plugin.vsxmake.autoupdate")

-- targets
target(PLUGIN_NAME)
    add_deps("commonlibsse-ng")

    add_rules("commonlibsse-ng.plugin", {
       name = PLUGIN_NAME,
       author = "StarkMP <discord: starkmp>",
       description = "SKSE64 plugin template using CommonLibSSE-NG and PrismaUI"
    })

    add_files("src/**.cpp")
    add_headerfiles("src/**.h")
    add_includedirs("src")
    set_pcxxheader("src/pch.h")

    after_build(function (target)
        local distdir = path.join(os.projectdir(), "dist", PLUGIN_NAME .. "_" .. PLUGIN_VERSION)
        local viewdir = path.join(distdir, "PrismaUI", "views", VIEW_NAME)
        local plugindir = path.join(distdir, "SKSE", "plugins")

        os.tryrm(distdir)
        os.mkdir(viewdir)
        os.mkdir(plugindir)

        os.cp(path.join(os.projectdir(), "view", "*"), viewdir)
        os.cp(target:targetfile(), plugindir)

        local symbolfile = target:symbolfile()
        if symbolfile and os.isfile(symbolfile) then
            os.cp(symbolfile, plugindir)
        end

        cprint("${bright green}creating distribution folder: ${clear}dist/%s_%s", PLUGIN_NAME, PLUGIN_VERSION)
    end)
