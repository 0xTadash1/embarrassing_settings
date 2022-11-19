define COPY_TO_CLIPBD
	[[ "$$(uname -s)" = Linux ]] \
		&& xclip -sel clip \
		|| pbcopy;
endef

define ENCRYPT
	age --passphrase $1 > $(1).age;
endef

define DECRYPT
	age --decrypt $1;
endef

passphrase:
	# Ensure that you have done bw {login,sync}.
	# `"fields": [{ "name": "Passphrase", "value": "...", ... }],`
	bw get item 7feb205a-f989-4103-92e7-af4201156bf9 \
		| sed -E 's/^.*"Passphrase","value":"|","type":.*$$//g' \
		| tee >($(COPY_TO_CLIPBD))

enc_all: passphrase
	for json in $$(find -name '*.json'); do \
		[[ "$${json}.age" -nt "$$json" ]] \
			|| $(call ENCRYPT,$${json}) \
	done

# Encrypt with a passphrase; you should already know or stored in bitwarden
enc_adguard: browser_extension/AdGuard_settings.json
	$(call ENCRYPT,$<)
enc_efyt: browser_extension/EnhancerForYoutube_settings.json
	$(call ENCRYPT,$<)

# Decrypt
dec_adguard: browser_extension/AdGuard_settings.json.age
	$(call DECRYPT,$<)
dec_efyt: browser_extension/EnhancerForYoutube_settings.json.age
	$(call DECRYPT,$<)

paste_into_efyt:
	{ [[ "$$(uname -s)" = Linux ]] \
		&& xclip -sel clip -o \
		|| pbpaste; \
	} > browser_extension/EnhancerForYoutube_settings.json
