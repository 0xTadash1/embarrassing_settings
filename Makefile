ADG_JSON := settings/adg.json
EFYT_JSON := settings/efyt.json


define CLIPBD_COPY_STDIN
	if type clipcopy > /dev/null 2>&1; then \
		clipcopy; \
	elif type xsel > /dev/null 2>&1; then \
		xsel --clipboard --input; \
	elif type xclip > /dev/null 2>&1; then \
		nohup xclip -selection clipboard -in > /dev/null 2>&1 & \
	elif [ -n "$$WAYLAND_DISPLAY" ]; then \
		nohup wl-copy > /dev/null 2>&1 & \
	else \
		pbcopy; \
	fi;
endef

define CLIPBD_PASTE
	if type clippaste > /dev/null 2>&1; then \
		clippaste; \
	elif type xsel > /dev/null 2>&1; then \
		xsel --clipboard --output; \
	elif type xclip > /dev/null 2>&1; then \
		xclip -selection clipboard -out; \
	elif [ -n "$$WAYLAND_DISPLAY" ]; then \
		wl-paste; \
	else \
		pbpaste; \
	fi;
endef

define ENCRYPT
	age --passphrase "$(1)" > "$(1).age";
endef

define DECRYPT
	{ one="$(1)"; age --decrypt "$(1)" > "$${one%.age}"; };
endef

PASSPHRASE:
	@ # Ensure that you have done bw {login,sync}.
	@ # `"fields": [{ "name": "Passphrase", "value": "...", ... }],`
	@ bw get item 7feb205a-f989-4103-92e7-af4201156bf9 \
		| sed -E 's/^.*"Passphrase","value":"|","type":.*$$//g' \
		| tee >($(CLIPBD_COPY_STDIN))
	@ echo

ENCRYPT_ALL: PASSPHRASE
	@ for json in $$(find -name '*.json'); do \
		[[ "$${json}.age" -ot "$$json" ]] \
		&& $(call ENCRYPT,$${json}) \
	done

# Encrypt with a passphrase; you should already know or stored in bitwarden
.PHONY
$(ADG_JSON).age: PASSPHRASE
	@ # Ensure that "$(ADG_JSON)" does exist.
	@ [ -f $(ADG_JSON) ]
	@ $(call ENCRYPT,$(ADG_JSON))
$(EFYT_JSON).age: PASSPHRASE
	@ # Ensure that "$(EFYT_JSON)" does exist.
	@ [ -f $(EFYT_JSON) ]
	@ $(call ENCRYPT,$(EFYT_JSON))

# Decrypt
$(ADG_JSON): PASSPHRASE
	@ # Ensure that "$(ADG_JSON).age" does exist.
	@ [ -f $(ADG_JSON).age ]
	@ $(call DECRYPT,$(ADG_JSON).age)
$(EFYT_JSON): PASSPHRASE
	@ # Ensure that "$(EFYT_JSON).age" does exist.
	@ [ -f $(EFYT_JSON).age ]
	@ $(call DECRYPT,$(EFYT_JSON).age)

# Useful targets for EFYT
COPY_CONTENT_EFYT:
	@ cat $(EFYT_JSON) | $(CLIPBD_COPY_STDIN)

PASTE_INTO_EFYT:
	@ ( $(CLIPBD_PASTE) ) > $(EFYT_JSON)
