#!/bin/bash

# Define colors for output highlighting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color (to reset)

# Function to identify the Linux distribution
identify_distro() {
    if [ -f /etc/os-release ]; then
        # The os-release file is standard in most distributions
        . /etc/os-release
        DISTRO=$ID
    else
        echo -e "${RED}Operating system not identified.${NC}"
        exit 1
    fi
}

# Function to display packages and their dependencies
show_packages_info() {
    echo -e "${CYAN}The following packages will be installed: ${BOLD}${PACKAGES[*]}${NC}"
    echo

    case $DISTRO in
        ubuntu|debian)
            echo -e "${YELLOW}Checking dependencies for Debian/Ubuntu...${NC}"
            for pkg in "${PACKAGES[@]}"; do
                echo -e "${GREEN}Package: ${BOLD}$pkg${NC}"
                # Show dependencies with apt-cache and highlight them
                apt-cache depends "$pkg"
            done
            ;;
        fedora)
            echo -e "${YELLOW}Checking dependencies for Fedora...${NC}"
            for pkg in "${PACKAGES[@]}"; do
                echo -e "${GREEN}Package: ${BOLD}$pkg${NC}"
                # Show dependencies with dnf repoquery and highlight them
                sudo dnf repoquery --requires "$pkg" 2>/dev/null
            done
            ;;
        arch)
            echo -e "${YELLOW}Checking dependencies for Arch Linux...${NC}"
            for pkg in "${PACKAGES[@]}"; do
                echo -e "${GREEN}Package: ${BOLD}$pkg${NC}"
                # Show dependencies with pactree and highlight them
                pactree -u "$pkg"
            done
            ;;
        opensuse*)
            echo -e "${YELLOW}Checking dependencies for openSUSE...${NC}"
            for pkg in "${PACKAGES[@]}"; do
                echo -e "${GREEN}Package: ${BOLD}$pkg${NC}"
                # Show dependencies with zypper info and highlight them
                sudo zypper info --requires "$pkg"
            done
            ;;
        *)
            echo -e "${RED}Unsupported distribution!${NC}"
            exit 1
            ;;
    esac
}

# Function to confirm dependency installation
confirm_dependencies_installation() {
    echo
    # Asking the user whether to install dependencies or not, with input on the same line
    echo -ne "${CYAN}Do you want to install the dependencies? (y/N): ${NC}"
    read install_deps
    if [[ "$install_deps" != "y" && "$install_deps" != "Y" ]]; then
        INSTALL_DEPENDENCIES=false
        echo -e "${YELLOW}Installing only the main packages without dependencies...${NC}"
    else
        INSTALL_DEPENDENCIES=true
        echo -e "${GREEN}Installing packages with dependencies...${NC}"
    fi
}

# Function to install packages with or without dependencies
# Note: If the user chooses not to install dependencies, only the main packages will be installed
install_packages() {
    case $DISTRO in
        ubuntu|debian)
            sudo apt update
            if [ "$INSTALL_DEPENDENCIES" = true ]; then
                sudo apt install -y "${PACKAGES[@]}"
            else
                sudo apt install --no-install-recommends -y "${PACKAGES[@]}"
            fi
            ;;
        fedora)
            if [ "$INSTALL_DEPENDENCIES" = true ]; then
                sudo dnf install -y "${PACKAGES[@]}"
            else
                sudo dnf install --setopt=install_weak_deps=False -y "${PACKAGES[@]}"
            fi
            ;;
        arch)
            sudo pacman -Sy
            if [ "$INSTALL_DEPENDENCIES" = true ]; then
                sudo pacman -S --noconfirm "${PACKAGES[@]}"
            else
                sudo pacman -S --asdeps --noconfirm "${PACKAGES[@]}"
            fi
            ;;
        opensuse*)
            sudo zypper refresh
            if [ "$INSTALL_DEPENDENCIES" = true ]; then
                sudo zypper install -y "${PACKAGES[@]}"
            else
                sudo zypper install --no-recommends -y "${PACKAGES[@]}"
            fi
            ;;
        *)
            echo -e "${RED}Unsupported distribution!${NC}"
            exit 1
            ;;
    esac
}

# Main function
main() {
    # Packages to be installed (add or remove packages as necessary)
    PACKAGES=("wget" "curl" "git")

    identify_distro
    echo -e "${GREEN}Distribution identified: ${BOLD}$DISTRO${NC}"

    # Display packages and dependencies
    show_packages_info

    # Ask the user whether to install dependencies
    confirm_dependencies_installation

    # Install packages
    install_packages

    echo -e "${GREEN}Installation completed!${NC}"
}

# Run the script
main
