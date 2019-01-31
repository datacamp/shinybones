# Satin

__Satin__ is an R package that provides a highly opinionated way to organize large, multi-page shiny apps. It allows users to focus on building independent modules for each page following a minimal set of conventions, and relegating all the boilerplate code involding in laying them out in the dashboard to a simple YAML configuration file.

![dashboard](https://i.imgur.com/egYB6tW.png)

## Installation

You can install `satin` from github:

```r
remotes::install_github('ramnathv/satin')
```

## Usage

You can easily scaffold a `satin` dashboard app using the `New Project` menu in `RStudio`

![satin-new-project](https://i.imgur.com/Cs9Tzxk.png)

## Conventions

1. A module referred to as `foo` needs to specify the following functions:

   - ui: `foo_ui`
   - server: `foo`
   - sidebar: `foo_sidebar_ui` (optional)
   
<br/>

2. The layout for the dashboard is specified in [YAML](_site.yml).

   - Each `menu` item becomes a menu item in the sidebar.
   - If a `menu` item has more than 1 child, the children become subitems.
   - If the child of a `menu` item has a `tabs` item, they are rendered as a
     `tabSetPanel`
   - Each item (page) is connected to a module by its name.
   

```yaml
name: Main Dashboard
sidebar:
  - text: Finance
    icon: briefcase
    menu:
      - text: Registrations
        module: registrations
      - text: Subscriptions
        tabs:
          - text: Individual
            module: subscribers_individual
          - text: Group
            module: subscribers_group

  - text: People
    icon: user
    menu:
      - text: People
        tabs:
          - text: Team Size
            module: team_size
          - text: Organogram
            module: organogram
```

## Development Process

1. Each page is independently developed as a standalone module.
2. Use the function `preview_module` to preview the module.
3. Add it to the dashboard by editing `_site.yml`.


## TODO

- [x] Hook up passing of data to each module
- [x] Wrap all utilities into a package
- [ ] Automatically check if tabnames are unique
- [x] Allow factory modules that can accept static parameters
- [ ] Fix bugs where when menu item has only one child, tabNames have to be same.
- [ ] Allow deep linking at the tab level (by default)
