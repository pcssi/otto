{% extends "compile:data/app/dev/Vagrantfile.tpl" %}

{% block vagrant_box %}
  config.vm.clone = ENV["OTTO_VAGRANT_LAYER_PATH"]
{% endblock %}

{% block vagrant_config %}
  {% if import_path != "" %}
  # Disable the default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
  {% endif %}

  # Make it so that `vagrant ssh` goes directly to the correct dir
  config.vm.provision "shell", inline:
    %Q[echo "cd {{ shared_folder_path }}" >> /home/vagrant/.profile]
{% endblock %}
