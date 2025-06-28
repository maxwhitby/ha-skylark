# Home Assistant Configuration

This repository contains the configuration for my Home Assistant installation, which integrates with the DISPLAYS-CC solar monitoring system.

## Overview

- **Platform**: Raspberry Pi (Linux 6.6.74-haos-raspi)
- **Related Project**: [DISPLAYS-CC](https://github.com/maxwhitby/DISPLAYS-CC) - Community Solar Power Monitoring System

## Structure

```
/config/
├── configuration.yaml    # Main configuration file
├── automations.yaml      # Automation rules
├── scripts.yaml         # Script definitions
├── scenes.yaml          # Scene configurations
├── groups.yaml          # Entity groupings
├── customize.yaml       # Entity customizations
├── secrets.yaml         # Sensitive data (git-ignored)
├── custom_components/   # Custom integrations
├── packages/           # Package configurations
├── www/               # Local web assets
└── .storage/          # HA internal storage (git-ignored)
```

## Security

Sensitive files are excluded via `.gitignore`. Never commit:
- `secrets.yaml`
- API keys or passwords
- `.storage/` directory contents
- Database files

## Setup

1. Clone this repository to your Home Assistant `/config` directory
2. Copy `secrets.yaml.example` to `secrets.yaml` (if provided)
3. Update `secrets.yaml` with your credentials
4. Restart Home Assistant

## Integration with DISPLAYS-CC

This HA instance may collect data for:
- Solar panel monitoring
- Battery status
- Energy consumption metrics
- Display system integration

## Contributing

When making changes:
1. Test configurations with `ha core check`
2. Create descriptive commit messages
3. Document any new integrations or automations

## License

This configuration is part of the broader DISPLAYS-CC project.