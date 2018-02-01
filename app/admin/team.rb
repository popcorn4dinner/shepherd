ActiveAdmin.register Team do

  permit_params :name, :channel_name, :webhook_url

  form do |f|
    f.inputs 'Team' do
      f.input :name
    end

    f.inputs 'Slack Settings' do
      f.input :webhook_url, label: 'Webhook URL'
      f.input :channel_name, label: 'Channel Name'
    end

    f.actions
  end
end
