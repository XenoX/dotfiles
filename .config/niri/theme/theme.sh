#!/usr/bin/env bash

## Copyright (C) 2020-2025 Aditya Shakya <adi1090x@gmail.com>
##
## Script To Apply Themes

## Theme ------------------------------------
DIR="$HOME/.config/niri"

## Directories ------------------------------
PATH_ALAC="$DIR/alacritty"
PATH_FOOT="$DIR/foot"
PATH_KITY="$DIR/kitty"
PATH_MAKO="$DIR/mako"
PATH_ROFI="$DIR/rofi"
PATH_WAYB="$DIR/waybar"
PATH_WLOG="$DIR/wlogout"

## Source Theme File ------------------------
CURRENT_THEME="$DIR/theme/current.bash"
DEFAULT_THEME="$DIR/theme/default.bash"
LIGHT_THEME="$DIR/theme/light.bash"
PYWAL_THEME="$HOME/.cache/wal/colors.sh"

## Check if current file exist
if [[ ! -e "$CURRENT_THEME" ]]; then
	touch "$CURRENT_THEME"
fi

## Default Theme
source_default() {
	cat ${DEFAULT_THEME} > ${CURRENT_THEME}
	source ${CURRENT_THEME}
	altbackground="`pastel color $background | pastel lighten 0.10 | pastel format hex`"
	altforeground="`pastel color $foreground | pastel darken 0.30 | pastel format hex`"
	modbackground=(`pastel gradient -n 3 $background $altbackground | pastel format hex`)
	accent="$color5"
	notify-send -h string:x-canonical-private-synchronous:sys-notify-dtheme -u normal -i ${PATH_MAKO}/icons/palette.png "Applying Default Theme..."
}

## Light Theme
source_light() {
	cat ${LIGHT_THEME} > ${CURRENT_THEME}
	source ${CURRENT_THEME}
	altbackground="`pastel color $background | pastel darken 0.15 | pastel format hex`"
	altforeground="`pastel color $foreground | pastel lighten 0.30 | pastel format hex`"
	modbackground=(`pastel gradient -n 3 $background $altbackground | pastel format hex`)
	accent="$color5"
	notify-send -h string:x-canonical-private-synchronous:sys-notify-dtheme -u normal -i ${PATH_MAKO}/icons/palette.png "Applying Light Theme..."
}

## Random Theme
source_pywal() {
	# Set you wallpaper directory here.
	WALLDIR="`xdg-user-dir PICTURES`/wallpapers"

	# Check for wallpapers
	check_wallpaper() {
		if [[ -d "$WALLDIR" ]]; then
			WFILES="`ls --format=single-column $WALLDIR | wc -l`"
			if [[ "$WFILES" == 0 ]]; then
				notify-send -h string:x-canonical-private-synchronous:sys-notify-noimg -u low -i ${PATH_MAKO}/icons/picture.png "There are no wallpapers in : $WALLDIR"
				exit
			fi
		else
			mkdir -p "$WALLDIR"
			notify-send -h string:x-canonical-private-synchronous:sys-notify-noimg -u low -i ${PATH_MAKO}/icons/picture.png "Put some wallpapers in : $WALLDIR"
			exit
		fi
	}

	# Run `pywal` to generate colors
	generate_colors() {	
		check_wallpaper
		if [[ `which wal` ]]; then
			notify-send -t 50000 -h string:x-canonical-private-synchronous:sys-notify-runpywal -i ${PATH_MAKO}/icons/timer.png "Generating Colorscheme. Please wait..."
			wal -q -n -s -t -e -i "$WALLDIR"
			if [[ "$?" != 0 ]]; then
				notify-send -h string:x-canonical-private-synchronous:sys-notify-runpywal -u normal -i ${PATH_MAKO}/icons/palette.png "Failed to generate colorscheme."
				exit
			fi
		else
			notify-send -h string:x-canonical-private-synchronous:sys-notify-runpywal -u normal -i ${PATH_MAKO}/icons/palette.png "'pywal' is not installed."
			exit
		fi
	}

	generate_colors
	cat ${PYWAL_THEME} > ${CURRENT_THEME}
	source ${CURRENT_THEME}
	altbackground="`pastel color $background | pastel lighten 0.10 | pastel format hex`"
	altforeground="`pastel color $foreground | pastel darken 0.30 | pastel format hex`"
	modbackground=(`pastel gradient -n 3 $background $altbackground | pastel format hex`)
	accent="$color5"
}

## Wallpaper ---------------------------------
apply_wallpaper() {
	sed -i -e "s#WALLPAPER=.*#WALLPAPER='$wallpaper'#g" ${DIR}/scripts/wallpaper
	bash ${DIR}/scripts/wallpaper &
}

## Alacritty ---------------------------------
apply_alacritty() {
	# alacritty : colors
	cat > ${PATH_ALAC}/colors.toml <<- _EOF_
		## Colors configuration
		[colors.primary]
		background = "${background}"
		foreground = "${foreground}"
		
		[colors.normal]
		black   = "${color0}"
		red     = "${color1}"
		green   = "${color2}"
		yellow  = "${color3}"
		blue    = "${color4}"
		magenta = "${color5}"
		cyan    = "${color6}"
		white   = "${color7}"
		
		[colors.bright]
		black   = "${color8}"
		red     = "${color9}"
		green   = "${color10}"
		yellow  = "${color11}"
		blue    = "${color12}"
		magenta = "${color13}"
		cyan    = "${color14}"
		white   = "${color15}"
	_EOF_
}

## Foot --------------------------------------
apply_foot() {
	# foot : colors
	cat > ${PATH_FOOT}/colors.ini <<- _EOF_
		## Colors configuration
		[colors]
		alpha=1.0
		foreground=${foreground:1}
		background=${background:1}

		## Normal/regular colors (color palette 0-7)
		regular0=${color0:1}  # black
		regular1=${color1:1}  # red
		regular2=${color2:1}  # green
		regular3=${color3:1}  # yellow
		regular4=${color4:1}  # blue
		regular5=${color5:1}  # magenta
		regular6=${color6:1}  # cyan
		regular7=${color7:1}  # white

		## Bright colors (color palette 8-15)
		bright0=${color8:1}   # bright black
		bright1=${color9:1}   # bright red
		bright2=${color10:1}   # bright green
		bright3=${color11:1}   # bright yellow
		bright4=${color12:1}   # bright blue
		bright5=${color13:1}   # bright magenta
		bright6=${color14:1}   # bright cyan
		bright7=${color15:1}   # bright white
	_EOF_
}

## Kitty ---------------------------------
apply_kitty() {
	# kitty : colors
	cat > ${PATH_KITY}/colors.conf <<- _EOF_
		## Colors configuration
		background ${background}
		foreground ${foreground}
		selection_background ${foreground}
		selection_foreground ${background}
		cursor ${foreground}
		
		color0 ${color0}
		color8 ${color8}
		color1 ${color1}
		color9 ${color9}
		color2 ${color2}
		color10 ${color10}
		color3 ${color3}
		color11 ${color11}
		color4 ${color4}
		color12 ${color12}
		color5 ${color5}
		color13 ${color13}
		color6 ${color6}
		color14 ${color14}
		color7 ${color7}
		color15 ${color15}
	_EOF_

	# reload kitty config
	kill -SIGUSR1 $(pidof kitty)
}

## Mako --------------------------------------
apply_mako() {
	# mako : config
	sed -i '/# Mako_Colors/Q' ${PATH_MAKO}/config
	cat >> ${PATH_MAKO}/config <<- _EOF_
		# Mako_Colors
		background-color=${background}
		text-color=${foreground}
		border-color=${modbackground[1]}
		progress-color=over ${accent}

		[urgency=low]
		border-color=${modbackground[1]}
		default-timeout=2000

		[urgency=normal]
		border-color=${modbackground[1]}
		default-timeout=5000

		[urgency=high]
		border-color=${color1}
		text-color=${color1}
		default-timeout=0
	_EOF_

	pkill mako && bash ${DIR}/scripts/notifications &
}

## Rofi --------------------------------------
apply_rofi() {
	# rofi : colors
	cat > ${PATH_ROFI}/shared/colors.rasi <<- EOF
		* {
		    background:      ${background};
		    background-alt1: ${modbackground[1]};
		    background-alt2: ${modbackground[2]};
		    foreground:      ${foreground};
		    selected:        ${accent};
		    active:          ${color2};
		    urgent:          ${color1};
		}
	EOF
}

## Waybar ------------------------------------
apply_waybar() {
	# waybar : colors
	cat > ${PATH_WAYB}/colors.css <<- EOF
		/** ********** Colors ********** **/
		@define-color background      ${background};
		@define-color background-alt1 ${modbackground[1]};
		@define-color background-alt2 ${modbackground[2]};
		@define-color foreground      ${foreground};
		@define-color selected        ${accent};
		@define-color black           ${color0};
		@define-color red             ${color1};
		@define-color green           ${color2};
		@define-color yellow          ${color3};
		@define-color blue            ${color4};
		@define-color magenta         ${color5};
		@define-color cyan            ${color6};
		@define-color white           ${color7};
	EOF

	pkill waybar && bash ${DIR}/scripts/statusbar &
}

## Wlogout -----------------------------------
apply_wlogout() {
	# wlogout : colors
	cat > ${PATH_WLOG}/colors.css <<- EOF
		/** ********** Colors ********** **/
		@define-color background      ${background};
		@define-color background-alt1 ${modbackground[1]};
		@define-color background-alt2 ${modbackground[2]};
		@define-color foreground      ${foreground};
		@define-color selected        ${accent};
		@define-color black           ${color0};
		@define-color red             ${color1};
		@define-color green           ${color2};
		@define-color yellow          ${color3};
		@define-color blue            ${color4};
		@define-color magenta         ${color5};
		@define-color cyan            ${color6};
		@define-color white           ${color7};
	EOF
}

## GTK Theme ---------------------------------
apply_gtk() {
	sed -i "$DIR"/scripts/gtkthemes \
		-e "s|THEME=.*|THEME='$gtk_theme'|g" \
		-e "s|ICONS=.*|ICONS='$gtk_icons'|g" \
		-e "s|FONT=.*|FONT='$gtk_font'|g" \
		-e "s|CURSOR=.*|CURSOR='$cursor_theme'|g"
		
	bash ${DIR}/scripts/gtkthemes &
}

# Geany -------------------------------------
apply_geany() {
	sed -i "$HOME"/.config/geany/geany.conf \
		-e "s/color_scheme=.*/color_scheme=$geany_colors/g"
}

## Hyprlock ----------------------------------
apply_hyprlock() {
	# convert colors to rgb format
	col_hl="`pastel color ${accent} | pastel format rgb | sed 's/rgb(\(.*\))/rgba(\1, 1.0)/'`"
	col_tx="`pastel color ${foreground} | pastel format rgb | sed 's/rgb(\(.*\))/rgba(\1, 1.0)/'`"
	col_oc="`pastel color ${modbackground[1]} | pastel format rgb | sed 's/rgb(\(.*\))/rgba(\1, 0.5)/'`"
	col_ic="`pastel color ${modbackground[2]} | pastel format rgb | sed 's/rgb(\(.*\))/rgba(\1, 0.5)/'`"
	col_fc="`pastel color ${color1} | pastel format rgb | sed 's/rgb(\(.*\))/rgba(\1, 1.0)/'`"

	sed -i "$HOME"/.config/niri/hyprlock.conf \
		-e "s|\$wallpaper =.*|\$wallpaper = $wallpaper|g" \
		-e "s|\$accent_color =.*|\$accent_color = $col_hl |g" \
		-e "s|\$accent_color_hex =.*|\$accent_color_hex = #${accent}FF |g" \
		-e "s|\$text_color =.*|\$text_color = $col_tx |g" \
		-e "s|\$text_color_hex =.*|\$text_color_hex = #${foreground}FF |g" \
		-e "s|\$inner_color =.*|\$inner_color = $col_ic |g" \
		-e "s|\$outer_color =.*|\$outer_color = $col_oc |g" \
		-e "s|\$fail_color =.*|\$fail_color = $col_fc |g"
}

## Niri --------------------------------------
apply_niri() {
	niri_cfg="$HOME/.config/niri/config.kdl"

	# BG Colors
	sed -i "$niri_cfg" \
		-e "s|background-color.*|background-color \"${modbackground[1]}\"|g" \
		-e "s|backdrop-color.*|backdrop-color \"${modbackground[2]}\"|g"

	# Focus Ring Solid Colors
	sed -i "$niri_cfg" \
		-e "/\/\/-FR-AC/{n;s|active-color[[:space:]]*".*"|active-color \"${accent}\"|}" \
		-e "/\/\/-FR-IAC/{n;s|inactive-color[[:space:]]*".*"|inactive-color \"${modbackground[2]}\"|}" \
		-e "/\/\/-FR-UC/{n;s|urgent-color[[:space:]]*".*"|urgent-color \"${color1}\"|}"

	# Focus Ring Gradient Colors
	sed -i "/\/\/-FR-CGS/{
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*active-gradient.*|\1active-gradient from=\"${accent}\" to=\"${color4}\" angle=90|
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*inactive-gradient.*|\1inactive-gradient from=\"${modbackground[2]}\" to=\"${modbackground[1]}\" angle=90|
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*urgent-gradient.*|\1urgent-gradient from=\"${color1}\" to=\"${color3}\" angle=90|
		}" "$niri_cfg"

	# Border Solid Colors
	sed -i "$niri_cfg" \
		-e "/\/\/-BD-AC/{n;s|active-color[[:space:]]*".*"|active-color \"${accent}\"|}" \
		-e "/\/\/-BD-IAC/{n;s|inactive-color[[:space:]]*".*"|inactive-color \"${modbackground[2]}\"|}" \
		-e "/\/\/-BD-UC/{n;s|urgent-color[[:space:]]*".*"|urgent-color \"${color1}\"|}"

	# Border Gradient Colors
	sed -i "/\/\/-BD-CGS/{
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*active-gradient.*|\1active-gradient from=\"${accent}\" to=\"${color4}\" angle=90 relative-to=\"workspace-view\"|
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*inactive-gradient.*|\1inactive-gradient from=\"${modbackground[2]}\" to=\"${modbackground[1]}\" angle=90 relative-to=\"workspace-view\" in=\"srgb-linear\"|
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*urgent-gradient.*|\1urgent-gradient from=\"${color1}\" to=\"${color3}\" angle=90|
		}" "$niri_cfg"

	# Tab Indicator Solid Colors
	sed -i "$niri_cfg" \
		-e "/\/\/-TI-AC/{n;s|active-color[[:space:]]*".*"|active-color \"${accent}\"|}" \
		-e "/\/\/-TI-IAC/{n;s|inactive-color[[:space:]]*".*"|inactive-color \"${modbackground[2]}\"|}" \
		-e "/\/\/-TI-UC/{n;s|urgent-color[[:space:]]*".*"|urgent-color \"${color1}\"|}"

	# Tab Indicator Gradient Colors
	sed -i "/\/\/-TI-CGS/{
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*active-gradient.*|\1active-gradient from=\"${accent}\" to=\"${color4}\" angle=90|
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*inactive-gradient.*|\1inactive-gradient from=\"${modbackground[2]}\" to=\"${modbackground[1]}\" angle=90|
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*urgent-gradient.*|\1urgent-gradient from=\"${color1}\" to=\"${color3}\" angle=90|
		}" "$niri_cfg"

	# Insert-Hint Solid Colors
	sed -i "$niri_cfg" \
		-e "/\/\/-IH-CS/{n;s|color[[:space:]]*".*"|color \"${accent}80\"|}"

	# Insert-Hint Gradient Colors
	sed -i "/\/\/-IH-CGS/{
		n; s|^\([[:space:]]*\(//\)\{0,1\}[[:space:]]*\).*gradient.*|\1gradient from=\"${accent}80\" to=\"${color4}80\" angle=45|
		}" "$niri_cfg"
}

## Source Theme Accordingly -----------------
if [[ "$1" == '--default' ]]; then
	source_default
	niri msg action do-screen-transition --delay-ms 500
	apply_gtk
	apply_geany
elif [[ "$1" == '--light' ]]; then
	source_light
	niri msg action do-screen-transition --delay-ms 500
	apply_gtk
	apply_geany
elif [[ "$1" == '--pywal' ]]; then
	source_pywal
	niri msg action do-screen-transition --delay-ms 500
else
	echo "Available Options: --default  --light  --pywal"
	exit 1
fi

## Execute Script ---------------------------
apply_wallpaper
apply_alacritty
apply_foot
apply_kitty
apply_mako
apply_rofi
apply_waybar
apply_wlogout
apply_hyprlock
apply_niri
