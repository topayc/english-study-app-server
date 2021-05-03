class Admin::CpdmAdvertisementsController < Admin::ApplicationController
  def index
    if !params[:type].present?
      @cpdm_advertisements = CpdmAdvertisement.all.order("id desc")
      @r=1
    elsif params[:type]=="1"
      @cpdm_advertisements = CpdmAdvertisement.where('remain > 0 and start_date <= ? and end_date >= ? and priority > 0 and priority < 6', Date.today, Date.today).order("id desc")
      @r=2
    elsif params[:type]=="0"
      @cpdm_advertisements = CpdmAdvertisement.where('remain < 0 or start_date > ? or end_date < ? or priority = 0 or priority > 5', Date.today, Date.today).order("id desc")
      @r=3
    end
    @cpdm_cor_name = Client.all
  end

  def show
    @cpdm_advertisement = CpdmAdvertisement.find(params[:id])
  end

  def new
    @cpdm_advertisement = CpdmAdvertisement.new
    @client_arr = []
    client_all = Client.all
    for i in 1..client_all.size
      client_str = "Cor Name : " + client_all[i-1].cor_name.to_s + " | Name : " + client_all[i-1].name.to_s
      @client_arr.push([].push(client_str, client_all[i-1].id))
    end
  end

  def create
    @cpdm_advertisement = CpdmAdvertisement.new(cpdm_advertisement_params)
    if params[:cpdm_advertisement][:ad_type] == '202'
      if params[:f_price].present?
        @cpdm_advertisement.additional_share_price = params[:f_price].to_i
      end
      if params[:f_reward].present?
        @cpdm_advertisement.reward = params[:f_reward].to_i
      end
      if params[:f_point].present?
        @cpdm_advertisement.point = params[:f_point].to_i
      end
      if params[:f_link].present?
        @cpdm_advertisement.link = params[:f_link].to_s
      end
    end
    if @cpdm_advertisement.save
      @cpdm_advertisement.update_attribute(:video_ver => 1) if params[:video].present?
      @cpdm_advertisement.save
      redirect_to admin_cpdm_advertisements_path, :notice => "Successfully created cpdm advertisement."
    else
      render :action => 'new'
    end
  end

  def edit
    @cpdm_advertisement = CpdmAdvertisement.find(params[:id])
    @client_arr = []
    client_all = Client.all
    for i in 1..client_all.size
      client_str = "Cor Name : " + client_all[i-1].cor_name.to_s + " | Name : " + client_all[i-1].name.to_s
      @client_arr.push([].push(client_str, i))
    end
  end

  def update
    @cpdm_advertisement = CpdmAdvertisement.find(params[:id])
    if params[:cpdm_advertisement][:ad_type] == '202'
      if params[:f_price].present?
        @cpdm_advertisement.additional_share_price = params[:f_price].to_i
      end
      if params[:f_reward].present?
        @cpdm_advertisement.reward = params[:f_reward].to_i
      end
      if params[:f_point].present?
        @cpdm_advertisement.point = params[:f_point].to_i
      end
      if params[:f_link].present?
        @cpdm_advertisement.link = params[:f_link].to_s
      end
    end
    if params[:video].present?
      params[:video].delete("@headers")
      params[:video].delete("@tempfile")
      params[:video].delete("@content_type")
      logger.debug "#{params[:video]}"
    end
      @cpdm_advertisement.video_ver += 1
      @cpdm_advertisement.save
    if @cpdm_advertisement.update_attributes(cpdm_advertisement_params)
      redirect_to admin_cpdm_advertisements_path, :notice  => "Successfully updated cpdm advertisement."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @cpdm_advertisement = CpdmAdvertisement.find(params[:id])
    @cpdm_advertisement.destroy
    redirect_to admin_cpdm_advertisements_url, :notice => "Successfully destroyed cpdm advertisement."
  end


  private
 
  def cpdm_advertisement_params
    params.require(:cpdm_advertisement).permit(:ad_type, :cli_id, :contract, :remain, :basic_show_price, :pay_type, :start_date, :end_date, :url, :priority, :ad_name, :length, :video, :skip)
  end
end
