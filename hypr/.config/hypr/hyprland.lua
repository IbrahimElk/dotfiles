-- =============================================================================
-- PROGRAMS / VARIABLES
-- =============================================================================

local terminal = "kitty"
local menu = "wofi --show drun"
local browser = "firefox"
local mainMod = "SUPER"

-- ============================================================================
-- Utilities
-- ============================================================================

local screenshot_dir = "~/pictures/screenshots"

local function run(cmd)
  return hl.dsp.exec_cmd(cmd)
end

-- =============================================================================
-- CONFIGURATION
-- =============================================================================

hl.config({
  cursor = {
    no_hardware_cursors = true,
  },

  general = {
    gaps_in = 5,
    gaps_out = 5,
    border_size = 2,

    col = {
      active_border = {
        colors = {
          "rgb(8aadf4)",
          "rgb(24273A)",
          "rgb(24273A)",
          "rgb(8aadf4)",
        },
        angle = 45,
      },
      inactive_border = {
        colors = {
          "rgb(24273A)",
          "rgb(24273A)",
          "rgb(24273A)",
          "rgb(27273A)",
        },
        angle = 45,
      },
    },

    resize_on_border = true,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    -- drop_shadow = true
    -- shadow_range = 4
    -- shadow_render_power = 3
    -- col.shadow = rgba(1a1a1aee)

    shadow = {
      enabled = true,
    },

    -- https://wiki.hyprland.org/Configuring/Variables/#blur
    blur = {
      enabled = true,
      size = 3,
      passes = 3,
      new_optimizations = true,
      vibrancy = 0.1696,
      ignore_opacity = true,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    -- pseudotile = 0
    preserve_split = 1,
    force_split = 2,
  },

  master = {
    new_status = "master",
  },

  misc = {
    disable_hyprland_logo = true,
    -- force_default_wallpaper = -1
    -- cursor goes to new window
    focus_on_activate = false,
  },

  input = {
    kb_layout = "be",
    kb_variant = "",
    kb_model = "",
    kb_options = "caps:swapescape",
    kb_rules = "",
    follow_mouse = 1,
    sensitivity = 0,

    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      drag_lock = true,
      disable_while_typing = true,
    },

    touchdevice = {
      transform = 0,
    },

    tablet = {
      -- transform = 0
      -- output = HDMI-A-1
      -- region_position = [100, 200]
      -- region_size = [1920, 1080]
      -- relative_input = true
      left_handed = true,
      -- active_area_size = [216, 135]
      -- active_area_position = [0, 0]
    },
  },
})

-- =============================================================================
-- MONITORS
-- =============================================================================

hl.monitor({
  output = "eDP-1",
  mode = "1920x1200@59.95000",
  position = "0x0",
  scale = 1,
})

-- rechterkant, extension
hl.monitor({
  output = "DP-3",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

-- linkerkant, bovenkant
hl.monitor({
  output = "DP-2",
  mode = "preferred",
  position = "auto",
  scale = 1,
  -- mirror = eDP-1
})

-- linkerkant, onderkant
hl.monitor({
  output = "DP-1",
  mode = "preferred",
  position = "auto",
  scale = 1,
})

-- To mirror screens:
-- hl.monitor({
--   output = "",
--   mode = "preferred",
--   position = "auto",
--   scale = 1,
--   mirror = "eDP-1",
-- })

-- =============================================================================
-- ANIMATIONS
-- =============================================================================

hl.curve("myBezier", {
  type = "bezier",
  points = {
    { 0.05, 0.9 },
    { 0.1, 1.05 },
  },
})

hl.animation({
  leaf = "windows",
  enabled = true,
  speed = 7,
  bezier = "myBezier",
})

hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = 7,
  bezier = "default",
  style = "popin 80%",
})

hl.animation({
  leaf = "border",
  enabled = true,
  speed = 10,
  bezier = "default",
})

hl.animation({
  leaf = "borderangle",
  enabled = true,
  speed = 8,
  bezier = "default",
})

hl.animation({
  leaf = "fade",
  enabled = true,
  speed = 7,
  bezier = "default",
})

hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 6,
  bezier = "default",
})

-- =============================================================================
-- KEYBINDINGS
-- =============================================================================

-- Terminal / browser / menu
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + O", hl.dsp.exit())

-- toggle float AND shove it above everything
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W", hl.dsp.window.pin())
hl.bind(mainMod .. " + W", hl.dsp.window.alter_zorder({ mode = "top" }))

-- hl.bind(mainMod .. " + W", hl.dsp.window.resize({ x = 1280, y = 720 }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + I", hl.dsp.layout("togglesplit"))

-- Fullscreen without hiding the Bar
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({
  mode = "maximized",
  action = "toggle",
}))

-- Rotate the current screen
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/hypr/rotate_screen.sh"))

-- Move focus with mainMod + letter keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + ampersand", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + Eacute", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + quotedbl", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + apostrophe", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + parenleft", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + Section", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + egrave", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + Exclam", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + ccedilla", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + agrave", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + Ampersand", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + Eacute", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + Quotedbl", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + Apostrophe", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + Parenleft", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + Section", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + egrave", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + Exclam", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + ccedilla", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + agrave", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
-- Re-enable the old mouse:273 resize binding if desired.
-- hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }))

-- Laptop multimedia keys for volume and LCD brightness
local volume_up   = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
local volume_down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
local volume_mute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
local mic_mute    = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

hl.bind("XF86AudioRaiseVolume", run(volume_up),   { repeating = true })
hl.bind("XF86AudioLowerVolume", run(volume_down), { repeating = true })
hl.bind("XF86AudioMute",        run(volume_mute))
hl.bind("XF86AudioMicMute",     run(mic_mute))

hl.bind("XF86MonBrightnessUp",   run("brightnessctl s 1%+"), { repeating = true,})
hl.bind("XF86MonBrightnessDown", run("brightnessctl s 1%-"), { repeating = true,})

-- Requires playerctl
hl.bind("XF86AudioNext",  run("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", run("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  run("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  run("playerctl previous"),    { locked = true })

-- ============================================================================
-- Clipboard
-- ============================================================================

local cliphist = "cliphist list | wofi --dmenu | cliphist decode | wl-copy"  
hl.bind(mainMod .. " + V", run(cliphist))

-- ============================================================================
-- Lock screen
-- ============================================================================

hl.bind(mainMod .. " + Y", run("~/.config/hypr/rotate_lock_bg_images.sh"))

-- ============================================================================
-- Screenshots
-- ============================================================================

local function screenshot(mode, extra_args)
  extra_args = extra_args or ""

  return run(
    "grimblast "
    .. extra_args
    .. " --notify copysave "
    .. mode
    .. " "
    .. screenshot_dir
    .. "/$(date +'%s.png')"
  )
end

-- entire screen
hl.bind("Print",  screenshot("screen"))
hl.bind("F12",    screenshot("screen"))

-- active window
hl.bind(mainMod .. " + Print",  screenshot("active", "--cursor --freeze"))
hl.bind(mainMod .. " + F12",    screenshot("active", "--cursor --freeze"))

-- select area
hl.bind(mainMod .. " + ALT + Print",  screenshot("area", "--cursor --freeze"))
hl.bind(mainMod .. " + ALT + F12",    screenshot("area", "--cursor --freeze"))

-- Toggle dunst notifications
hl.bind(mainMod .. " + N", run("dunstctl set-paused toggle"))

-- =============================================================================
-- ENVIRONMENT
-- =============================================================================

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Nvidia / VA-API environment
hl.env("LIBVA_DRIVER_NAME", "iHD")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- Toolkit Backend Variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- =============================================================================
-- DEVICE-SPECIFIC INPUT
-- =============================================================================

-- hl.device({
--   name = "sigmachip-trust-keyboard",
--   kb_layout = "be",
--   keybinds = 1, -- 0 = this keyboard will NOT trigger Hyprland keybinds
-- })

-- bindel = , F3, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+
-- bindel = , F2, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-
-- bindel = , F1, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
-- bindel = , F7, exec, brightnessctl s 1%+
-- bindel = , F6, exec, brightnessctl s 1%-
-- bindl  = , F4, exec, playerctl play-pause

-- =============================================================================
-- AUTOSTART
-- =============================================================================

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
  hl.exec_cmd("/usr/bin/dunst")
  hl.exec_cmd("waybar")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("awww img ~/pictures/wallpapers/astronaut.png")
  hl.exec_cmd("hypridle")
end)

-- =============================================================================
-- WINDOW RULES
-- =============================================================================

hl.window_rule({
  match = {
      class = ".*",
  },
  suppress_event = "maximize",
})

hl.window_rule({
  match = {
      class = "^kitty$",
  },
  opacity = "0.90 0.90",
})
