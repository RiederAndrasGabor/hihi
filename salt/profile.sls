{% if grains['os']=='Debian' %}
{# For non-interactive shells, virtualenvwrapper commands 
   ('workon' etc.) are not sourced automatically #}
/etc/profile:
  file.append:
    - text:
      - "#Line below added for Debian by CIRCLE Salt installer"
      - . /etc/bash_completion
{% endif %}

