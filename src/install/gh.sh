function gh::setup() {
	local tarball_url gp_credentials;

	# Install gh
	log::info "Installing gh CLI";
	tarball_url="$(curl -Ls "https://api.github.com/repos/cli/cli/releases/latest" \
		| grep -o 'https://github.com/.*/releases/download/.*/gh_.*linux_amd64.tar.gz')";
	curl -Ls "$tarball_url" | sudo tar -C /usr --strip-components=1 -xpzf -;

	# Login into gh
	gp ports await 23000 1>/dev/null;
	gp_credentials="$(printf '%s\n' host=github.com | gp credential-helper get)";
	if [[ "$gp_credentials" =~ password=(.*) ]]; then {
		printf '%s\n' "${BASH_REMATCH[1]}" | gh auth login --with-token;
	} else {
		log::error "Failed to get auth token for gh" || exit 1;
	} fi
}