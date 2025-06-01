# env.nu
#
# Installed by:
# version = "0.103.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

def save_if_not_exists [
    data: any        # 要保存的数据
    path: string     # 目标文件路径
] {
    if not ($path | path exists) {
        $data | save --force $path
        $"File saved to ($path)"
    } else {
        $"File ($path) already exists, skipping save."
    }
}

# Create vendor autoload directory
let vendor_autoload = ($nu.data-dir | path join "vendor/autoload")
mkdir $vendor_autoload

# carapace
carapace _carapace nushell | save -f ($vendor_autoload | path join "carapace.nu")

# zoxide
# zoxide init nushell | save -f ($vendor_autoload | path join "zoxide.nu")

# atuin
atuin init nu | save -f ($vendor_autoload | path join "atuin.nu")
