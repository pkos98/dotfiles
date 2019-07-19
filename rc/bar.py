from i3pystatus import Status

status = Status()

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
                format="%a %-d %b %X",
                on_leftclick="gsimplecal")

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
status.register("battery",
                format="{status} {percentage:.0f}%",
                alert=True,
                alert_percentage=15,
                status={
                    "DIS": " ",
                    "CHR": " ",
                    "FULL": " ",
                },)

status.register("network",
    interface="enp0s20f0u1",
    format_down="",
    format_up=" {v4cidr}",)

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
                interface="wlp2s0",
                format_down="",
                format_up=" {v4}@{essid}")

# Shows disk usage of /
# Format:
# 42/128G [86G]
status.register("disk",
                path="/",
                format=" {used}/{total}G",)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
                format="  {volume_bar} {volume}",
                format_muted="[muted]",
                on_leftclick="switch_mute",
                on_rightclick="pavucontrol",
                bar_type="horizontal")

status.register("backlight",
                format=" {percentage}%")

status.run()
