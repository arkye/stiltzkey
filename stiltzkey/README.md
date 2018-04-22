# Stiltzkey Phoenix Cheat Sheet

## Start Learning

* Official website: http://www.phoenixframework.org/
* Guides: http://phoenixframework.org/docs/overview
* Docs: https://hexdocs.pm/phoenix
* Mailing list: http://groups.google.com/group/phoenix-talk
* Source: https://github.com/phoenixframework/phoenix

## Cheat Sheet

### i18n with [GNU gettext](https://www.gnu.org/software/gettext/)

#### Update i18n Files

```bash
sudo docker-compose -p stzk exec phoenix mix gettext.extract
sudo docker-compose -p stzk exec phoenix mix gettext.merge priv/gettext
```

### Routes

#### List Routes

```bash
sudo docker-compose -p stzk exec phoenix mix phx.routes
```
