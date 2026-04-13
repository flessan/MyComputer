 # +_= MyComLutr - Modern & Productive Terminal Configuration

🌐 [🇬🇧 English](#english) | [🇮🇩 Bahasa Indonesia](#bahasa-indonesia)

---

## 🇬🇧 English

A highly optimized `.bashrc` configuration for Linux developers and power users (primarily Arch Linux). It delivers a modern terminal interface, built-in productivity tools, startup optimizations, and seamless integration with popular CLI utilities.

### ✨ Key Features

#### 🎨 UI & Prompt
- **Modern Prompt**: Auto-integrates with [Starship Prompt](https://starship.rs/).
- **Line Editor**: Full support for [Ble.sh](https://github.com/akinomyoya/ble.sh) (syntax highlighting, auto-suggestions, vi/emacs keybindings).
- **Modern Listing & Viewing**: `ls`/`ll` aliased to `eza` (icons, Git status, colors), `cat` aliased to `bat`.
- **Colored Man Pages**: Custom `LESS_TERMCAP` variables for clean, highlighted `man`/`less` output.

#### 📦 Package & System Management (Arch Linux)
- **Package Aliases**: `update`, `update-full`, `install`, `remove`, `search`, `cleanup`, `orphans` (using `yay`/`pacman`).
- **Auto-Suggest Missing Commands**: `command_not_found_handle` detects missing packages via `pkgfile` and suggests installation commands.
- **Quick System Info**: `cpu`, `gpu`, `disks`, `kernel`, `uptime`, `myip`, `ports`, `ps`.

#### 🛠️ Productivity & Custom Functions
- **Smart Fixer (`fix`)**: Corrects common typos (`cd..` → `cd ..`), auto-adds `sudo`, or converts `apt` → `pacman`.
- **Directory Bookmarks (`bm`, `gm`)**: Save & jump to favorite directories instantly.
- **Todo Manager (`todo`)**: Simple CLI task manager with checklist (`[ ]`/`[x]`), supports bash-completion.
- **Notes System (`note`)**: Create, edit, list, and delete centralized Markdown notes.
- **Archive Manager (`extract` / `compress`)**: Extract/compress 15+ formats (`tar`, `zip`, `7z`, `zst`, `deb`, `rpm`, etc.) with one command.
- **Git Aliases**: `ga`, `gc`, `gco`, `gcb`, `gl`, `gp`, `gundo`, etc. + `quickpush` for instant add-commit-push.
- **Daily Utilities**: `calc`, `jsonf`, `genpass`, `tmpd`, `backup`, `weather` (default: Banjarmasin), `pskill`, `fsearch`, `ff`.

#### ⚡ Performance & Optimizations
- **Lazy Loading Docker**: `docker`, `dc`, `dex` load only on first use, drastically reducing shell startup time.
- **Advanced Shell Options**: `autocd`, `cdspell`, `globstar`, `nullglob`, `extglob`, `noclobber`, `nocasematch`, etc.
- **Smart History**: Timestamped, deduplicated, ignores common commands (`ls`, `cd`, `clear`, etc.), append mode.

#### 🔌 Extensions & Customization (Ready-to-Enable)
- **FZF Integration**: Uncomment the block to enable fuzzy search (`fh`, `vf`, `fcd`, `fkill`).
- **Custom Keybindings**: `Ctrl+Left/Right` word navigation & history search (auto-adapts to Ble.sh or standard Bash).

---

### 📦 Prerequisites
Install recommended packages (Arch Linux):
```bash
yay -S ble.sh eza bat starship fastfetch jq bc pkgfile fd fzf
```
*(Note: `fzf`, `fd`, and `docker` are optional. The script runs normally without them.)*

### 🚀 Installation
1. **Backup old config:**
   ```bash
   cp ~/.bashrc ~/.bashrc.backup
   ```
2. **Apply this config:** Replace your `~/.bashrc` with this script.
3. **Reload:**
   ```bash
   source ~/.bashrc
   ```

### 📖 Quick Usage Guide
| Command | Description |
|---|---|
| `fix` | Auto-fix last command typos or add missing `sudo` |
| `bm <name>` / `gm <name>` | Save / jump to a directory bookmark |
| `todo add <task>` | Add a new task |
| `todo list` | Show tasks with checkboxes |
| `note list` / `note <name>` | List notes or create/edit a new note |
| `extract file.7z` | Auto-extract archive by extension |
| `compress folder` | Compress folder to `tar.gz` (default) |
| `quickpush "msg"` | Git add + commit + push in one line |
| `myip` | Show public & local IPv4 |
| `weather [city]` | Check weather (default: Banjarmasin) |
| `genpass [len]` | Generate random password (default: 24 chars) |

### ⚙️ Customization
- **Change Default City**: Edit `local location="${1:-Banjarmasin}"` in the `weather()` function.
- **Enable FZF**: Uncomment the `# FZF Integration` block. Ensure `fzf` & `fd` are installed.
- **Change Editor**: Modify `export EDITOR="nano"` in the Environment section.
- **Disable Welcome Screen**: Comment out `show_greeting` at the end of the file.

### 📝 Data Storage Paths
| Path | Purpose |
|---|---|
| `~/.local/share/bash_bookmarks` | Directory bookmarks (`name:path`) |
| `~/.local/share/notes/` | Markdown notes storage |
| `~/.local/share/todo.txt` | Todo list file |

> ⚠️ **Note**: Optimized for **Arch Linux**. Adapt package aliases (`yay`/`pacman`) for other distros. `ble.sh` & `starship` are optional and auto-detected.

---

## 🇮🇩 Bahasa Indonesia

Konfigurasi `.bashrc` yang sangat dioptimalkan untuk pengembang dan pengguna Linux tingkat lanjut (khususnya Arch Linux). Menyediakan antarmuka terminal modern, alat produktivitas bawaan, optimasi kecepatan startup, dan integrasi mulus dengan utilitas CLI populer.

### ✨ Fitur Utama

#### 🎨 Tampilan & Prompt
- **Prompt Modern**: Integrasi otomatis dengan [Starship Prompt](https://starship.rs/).
- **Line Editor**: Dukungan penuh untuk [Ble.sh](https://github.com/akinomyoya/ble.sh) (syntax highlighting, auto-suggestions, keybinding vi/emacs).
- **Listing & View Modern**: Alias `ls`/`ll` menggunakan `eza` (ikon, status Git, warna), `cat` menggunakan `bat`.
- **Man Pages Berwarna**: Variabel `LESS_TERMCAP` kustom untuk output `man`/`less` yang rapi dan berwarna.

#### 📦 Manajemen Paket & Sistem (Arch Linux)
- **Alias Paket**: `update`, `update-full`, `install`, `remove`, `search`, `cleanup`, `orphans` (menggunakan `yay`/`pacman`).
- **Saran Otomatis**: `command_not_found_handle` mendeteksi paket yang hilang via `pkgfile` dan menyarankan perintah instalasi.
- **Info Sistem Cepat**: `cpu`, `gpu`, `disks`, `kernel`, `uptime`, `myip`, `ports`, `ps`.

#### 🛠️ Produktivitas & Fungsi Kustom
- **Perbaikan Cerdas (`fix`)**: Memperbaiki typo umum (`cd..` → `cd ..`), otomatis menambah `sudo`, atau mengonversi `apt` → `pacman`.
- **Bookmark Direktori (`bm`, `gm`)**: Simpan & panggil direktori favorit secara instan.
- **Manajer Todo (`todo`)**: Task manager CLI sederhana dengan checklist (`[ ]`/`[x]`), dilengkapi bash-completion.
- **Sistem Catatan (`note`)**: Buat, edit, daftar, & hapus catatan Markdown terpusat.
- **Manajer Arsip (`extract` / `compress`)**: Ekstrak/kompres 15+ format (`tar`, `zip`, `7z`, `zst`, `deb`, `rpm`, dll.) dalam satu perintah.
- **Alias Git Lengkap**: `ga`, `gc`, `gco`, `gcb`, `gl`, `gp`, `gundo`, dll. + `quickpush` untuk add-commit-push instan.
- **Utilitas Harian**: `calc`, `jsonf`, `genpass`, `tmpd`, `backup`, `weather` (default: Banjarmasin), `pskill`, `fsearch`, `ff`.

#### ⚡ Optimasi & Performa
- **Lazy Loading Docker**: `docker`, `dc`, `dex` hanya dimuat saat pertama kali dipanggil, mempercepat startup terminal secara signifikan.
- **Opsi Shell Lanjutan**: `autocd`, `cdspell`, `globstar`, `nullglob`, `extglob`, `noclobber`, `nocasematch`, dll.
- **History Cerdas**: Format waktu, deduplikasi, mengabaikan perintah umum (`ls`, `cd`, `clear`, dll.), mode append.

#### 🔌 Ekstensi & Kustomisasi (Siap Pakai)
- **Integrasi FZF**: Hapus tanda `#` di blok `# FZF Integration` untuk mengaktifkan pencarian fuzzy (`fh`, `vf`, `fcd`, `fkill`).
- **Keybinding Kustom**: Navigasi kata `Ctrl+Kiri/Kanan` & pencarian history (otomatis menyesuaikan Ble.sh atau Bash standar).

---

### 📦 Prasyarat
Instal paket yang direkomendasikan (Arch Linux):
```bash
yay -S ble.sh eza bat starship fastfetch jq bc pkgfile fd fzf
```
*(Catatan: `fzf`, `fd`, dan `docker` bersifat opsional. Skrip tetap berfungsi normal tanpa paket ini.)*

### 🚀 Instalasi
1. **Backup konfigurasi lama:**
   ```bash
   cp ~/.bashrc ~/.bashrc.backup
   ```
2. **Terapkan konfigurasi ini:** Ganti isi `~/.bashrc` Anda dengan skrip ini.
3. **Muat ulang:**
   ```bash
   source ~/.bashrc
   ```

### 📖 Panduan Penggunaan Cepat
| Perintah | Deskripsi |
|---|---|
| `fix` | Perbaiki typo perintah terakhir atau tambahkan `sudo` yang hilang |
| `bm <nama>` / `gm <nama>` | Simpan / lompat ke bookmark direktori |
| `todo add <tugas>` | Tambah tugas baru |
| `todo list` | Tampilkan tugas dengan checkbox |
| `note list` / `note <nama>` | Lihat daftar catatan atau buat/edit catatan baru |
| `extract file.7z` | Ekstrak arsip otomatis sesuai ekstensi |
| `compress folder` | Kompres folder menjadi `tar.gz` (default) |
| `quickpush "pesan"` | Git add + commit + push dalam satu baris |
| `myip` | Tampilkan IP publik & lokal IPv4 |
| `weather [kota]` | Cek cuaca (default: Banjarmasin) |
| `genpass [panjang]` | Generate password acak (default: 24 karakter) |

### ⚙️ Kustomisasi
- **Ganti Kota Default Cuaca**: Edit `local location="${1:-Banjarmasin}"` pada fungsi `weather()`.
- **Aktifkan FZF**: Hapus tanda `#` di blok `# FZF Integration`. Pastikan `fzf` & `fd` terinstal.
- **Ganti Editor Default**: Ubah `export EDITOR="nano"` di bagian Environment.
- **Nonaktifkan Sapaan Awal**: Beri komentar pada baris `show_greeting` di akhir file.

### 📝 Path Penyimpanan Data
| Path | Kegunaan |
|---|---|
| `~/.local/share/bash_bookmarks` | Database bookmark direktori (`nama:path`) |
| `~/.local/share/notes/` | Folder penyimpanan catatan `.md` |
| `~/.local/share/todo.txt` | File daftar tugas |

> ⚠️ **Catatan**: Dioptimalkan untuk **Arch Linux**. Sesuaikan alias paket (`yay`/`pacman`) untuk distro lain. `ble.sh` & `starship` bersifat opsional dan akan terdeteksi otomatis.
```

💡 **Cara Pakai**: 
Simpan kode di atas sebagai `README.md`. Struktur ini mengikuti standar repositori open-source multilingual. Navigasi di atas akan langsung mengarah ke bagian bahasa yang dipilih, dan semua tabel, blok kode, serta tautan sudah diformat rapi untuk GitHub/GitLab/Codeberg.
