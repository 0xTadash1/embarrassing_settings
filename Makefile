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
		| jq '.fields[0].value' \
		| tr -d '"' | tr -d $$'\n' \
		| tee >($(COPY_TO_CLIPBD))

encrypt_all_up_to_date: passphrase
	for json in $$(find -name '*.json'); do \
		[[ "$${json}.age" -nt "$$json" ]] \
			|| $(call ENCRYPT,$${json}) \
	done

# Encrypt with a passphrase; you should already know or stored in bitwarden
adguard.age: browser_extension/AdGuard_settings.json
	$(call ENCRYPT,$<)
efyt.age: browser_extension/EnhancerForYoutube_settings.json
	$(call ENCRYPT,$<)

# Decrypt
adguard: browser_extension/AdGuard_settings.json.age
	$(call DECRYPT,$<)
efyt: browser_extension/EnhancerForYoutube_settings.json.age
	$(call DECRYPT,$<)
