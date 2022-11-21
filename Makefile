ADGUARD_JSON := browser_extension/AdGuard_settings.json
EFYT_JSON := browser_extension/EnhancerForYoutube_settings.json


define COPY_TO_CLIPBD
	[[ "$$(uname -s)" = Linux ]] \
		&& xclip -sel clip \
		|| pbcopy;
endef

define ENCRYPT
	age --passphrase $1 > $(1).age;
endef

define DECRYPT
	_one=$1; age --decrypt $1 > $${_one%.age};
endef


passphrase:
	# Ensure that you have done bw {login,sync}.
	# `"fields": [{ "name": "Passphrase", "value": "...", ... }],`
	@ bw get item 7feb205a-f989-4103-92e7-af4201156bf9 \
		| sed -E 's/^.*"Passphrase","value":"|","type":.*$$//g' \
		| tee >($(COPY_TO_CLIPBD))
	@ echo

enc_all: passphrase
	@ for json in $$(find -name '*.json'); do \
		[[ "$${json}.age" -nt "$$json" ]] \
			|| $(call ENCRYPT,$${json}) \
	done

# Encrypt with a passphrase; you should already know or stored in bitwarden
enc_adguard: $(ADGUARD_JSON) passphrase
	@ $(call ENCRYPT,$<)
enc_efyt: $(EFYT_JSON) passphrase
	@ $(call ENCRYPT,$<)

# Decrypt
dec_adguard: $(ADGUARD_JSON).age passphrase
	@ $(call DECRYPT,$<)
dec_efyt: $(EFYT_JSON).age passphrase
	@ $(call DECRYPT,$<)

# Useful targets for EFYT
copy_efyt_to_clipbd:
	@ cat $(EFYT_JSON) | { $(COPY_TO_CLIPBD) }

paste_into_efyt:
	@ { [[ "$$(uname -s)" = Linux ]] \
		&& xclip -sel clip -o \
		|| pbpaste; \
	} > $(EFYT_JSON)
