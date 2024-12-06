gamescope.config.known_displays.onexplayer_fly_oled = {
    pretty_name = "OneXPlayer Fly OLED",
    dynamic_refresh_rates = {
        60, 90, 120, 144
    },
    hdr = {
        supported = true,
        force_enabled = true,
        eotf = gamescope.eotf.gamma22,
        max_content_light_level = 700,
        max_frame_average_luminance = 400,
        min_content_light_level = 0
    },
    dynamic_modegen = function(base_mode, refresh)
        debug("Generating mode "..refresh.."Hz for OneXPlayer Fly OLED")
        local mode = base_mode

        gamescope.modegen.set_resolution(mode, 1080, 1920)

        -- Horizontal timings: Hfront, Hsync, Hback
        gamescope.modegen.set_h_timings(mode, 80, 44, 156)
        -- Vertical timings: Vfront, Vsync, Vback
        gamescope.modegen.set_v_timings(mode, 48, 2, 14)

        mode.clock = gamescope.modegen.calc_max_clock(mode, refresh)
        mode.vrefresh = gamescope.modegen.calc_vrefresh(mode)

        return mode
    end,
    matches = function(display)
        -- There are multiple revisions of the OneXPlayer Fly OLED
        -- They all should have the same panel
        -- lcd_types is just in case there are different panels
        local lcd_types = {
            { vendor = "YHB", model = "YHB02P25" },
        }

        for index, value in ipairs(lcd_types) do
            if value.vendor == display.vendor and value.model == display.model then
                debug("[onexplayer_fly_oled] Matched vendor: "..value.vendor.." model: "..value.model)
                return 5100
            end
        end

        return -1
    end
}
debug("Registered OneXPlayer Fly OLED as a known display")
--debug(inspect(gamescope.config.known_displays.onexplayer_fly_oled))