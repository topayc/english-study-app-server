class Api::EtcController < ApplicationController
  skip_before_filter :verify_authenticity_token
  require File.dirname(__FILE__)+'/../../../lib/qpcon_manager.rb'

  def refund_info
    @status = true
    @msg = ""

    @user = User.find_by_id(params[:id])
    @ment = MentList.find_by_kind("refund")

    if !@user.present?
      @status = false
      @msg = "Not exist user"
    elsif !@ment.present?
      @status = false
      @msg = "not exist refund ment"
    end

    if @status == true
      @current_reward = @user.current_reward
      @content = @ment.content
    end

  end

  def get_bank_list
    @status = true
    @msg = ""

    @bank_list = BankList.all.pluck(:name).uniq
 
  end



  def refund
    @status = true
    @msg = "requested"

    if !params[:user_id].present? || !params[:name].present? || !params[:bank].present? || !params[:account].present? || !params[:amount].present? || !params[:password].present?
      @status=false
      @msg = "not exist some of params"
    else
      @user = User.find_by_id(params[:user_id])

      if !@user.present?
        @status=false
        @msg = "not exist user"
      elsif !@user.authenticate(params[:password]).present?
        @status=false
        @msg="incorrect password"
      else

        user_id = params[:user_id].to_i
        name = params[:name].to_s
        bank = params[:bank].to_s
        account = params[:account].to_s
        amount = params[:amount].to_i
        #password = params[:password].to_s
        

        @current_reward = @user.current_reward

        if !(@current_reward >= amount)
          @status=false
          @msg="need more money"
        else

          # reward process
          @token_user_id=user_id
          @token_reward_type=7000               # reward_tpye : REFUND = 7000
          @token_title="refund"
          @token_sub_title="request"
          @token_reward=(-1)*amount

          # Refund request history (refund only)
          @token_name=name
          @token_bank=bank
          @token_account=account
          @token_comment="request"

          process_reward_general

        end
      end

    end
  end

  def get_purchase_list
    @status = true
    @msg = ""

    @user=User.find_by_id(params[:id])
    if !@user.present?
      @status=false
      @msg="not exist user_id"
    elsif !params[:coupon_type].present?
      @status=false
      @msg="not exist coupon_type params"
    elsif params[:coupon_type]!="1" && params[:coupon_type]!="0"
      @status=false
      @msg="invalid coupon_type"
    end

    if @status == true

      if params[:coupon_type].to_i == 0

        @coupons=MyCoupon.where('user_id = ? and coupon_type = ?', params[:id] ,params[:coupon_type]).order("coupon_id")
        if @coupons.present?
          @product=[]
          chk=1
          @coupons.each do |p|
            tmp_hash = {}
            tmp_hash[:order_id] = p.coupon_id
            if p.availability == 1
              tmp_hash[:is_used] = false
              tmp_hash[:is_expired] = false
              tmp_hash[:is_canceled] = false
            else
              tmp_hash[:is_used] = true
              tmp_hash[:is_expired] = true
            tmp_hash[:is_canceled] = true
            end
            tmp_hash[:created_at] = p.created_at
            tmp_hash[:name] = nil                                # for hash format preserve
            tmp_hash[:price] = nil
            tmp_hash[:maker] = nil
            tmp_hash[:image] = nil

            #temp val ------------------
            tmp_hash[:coupon_id] = p.coupon_id
            tmp_hash[:availability] = p.availability
            # -----------------

            q=CouponFreeInfo.find_by_id(p.coupon_id)
            if q.present?
              tmp_hash[:name] = q.name
              tmp_hash[:maker] = q.place
              tmp_hash[:image] = q.image_url                     # need to check later

              #temp val ------------------------
              tmp_hash[:place] = q.place
              # ----------------------------

            end

            if p.coupon_id != 1 && p.coupon_id != 2 && p.coupon_id != 3 && p.coupon_id != 4 then chk = 1 end
            @product.push(tmp_hash) if q.valid_start <= Date.today && q.valid_end >= Date.today && chk==1
            if p.coupon_id == 1 || p.coupon_id == 2 || p.coupon_id == 3 || p.coupon_id == 4 then chk = 0 end
          end
        end

      elsif params[:coupon_type].to_i == 1

        @coupons=Order.where('user_id = ?', params[:id]).order("created_at DESC")
        if @coupons.present?
          @product=[]
          @coupons.each do |p|

            tmp_hash = {}
            tmp_hash[:order_id]  = p.order_id
            tmp_hash[:is_used]    = p.is_used
            tmp_hash[:is_expired] = p.is_expired
            tmp_hash[:is_canceled] = p.is_canceled
            tmp_hash[:created_at] = p.created_at
            tmp_hash[:name] = nil
            tmp_hash[:price] = nil
            tmp_hash[:maker] = nil
            tmp_hash[:image] = nil

            q=QpconProduct.find_by_product_id(p.product_id)
            if q.present?
              tmp_hash[:name]  = q.product_name
              tmp_hash[:price] = q.market_cost
              tmp_hash[:maker] = q.market_name
              tmp_hash[:image] = q.img_url_250
            end

            @product.push(tmp_hash)
          end
        end

      end


    end
  end

  def show_cpx_list
    @status=true
    @msg=""

    if !(user=User.find_by_id(params[:id])).present?
      @status=false
      @msg="not exist user"
    else
      my_cpx_ad_ids=AdvertiseCpxLog.where('user_id = ?', params[:id]).pluck(:ad_id).uniq
      trash = CpxAdvertisement.where('end_date < ? and id in (?)', Date.today, my_cpx_ad_ids).pluck(:id).uniq
      my_cpx_ad_ids = my_cpx_ad_ids - trash
      if my_cpx_ad_ids.count==0
        @msg="not exist log"
      else
        @cpx_list=[]
        my_cpx_ad_ids.reverse
        my_cpx_ad_ids.each do |i|
=begin
        (0..my_cpx_ad_ids.count-1).each do |i|
          ad_id=my_cpx_ad_ids[i]
          my_cpx_recent=AdvertiseCpxLog.where('user_id = ? and ad_id = ?',params[:id], ad_id).order("id DESC").order("created_at DESC").first
          ad_info=CpxAdvertisement.find_by_id(ad_id)
          if my_cpx_recent.act == 1
            if ad_info.remain <= 0
              act = 9
            else
              act = 1
            end
          elsif my_cpx_recent.act == 2
            if ad_info.remain <= 0
              act = 9
            else
              act = 2
            end
          elsif my_cpx_recent.act == 3
            act = 3
          elsif my_cpx_recent.act == 4
            if ad_info.remain <= 0
              act = 9
            else
              act = 4
            end
          else
            act = 0
          end
=end
          act = 2

          act = 3 if AdvertiseCpxLog.where('user_id = ? and ad_id = ? and act = 3', params[:id], i).present?

          ad_info = CpxAdvertisement.find_by_id(i)
          act = 9 if ad_info.remain <= 0

          tmp_hash={:ad_id => i, :ad_type => ad_info.ad_type, :act => act, :name => ad_info.ad_name, :image => ad_info.ad_image.url, :reward => ad_info.reward, :point => ad_info.point}
          @cpx_list.push(tmp_hash)
        end
      end
    end
  end


  def my_home
    @status = true
    @msg = ""
 
    user=User.find_by_id(params[:id])
    if !user.present?
      @status=false
      @msg="not exist user"
    elsif !params[:category].present? || !params[:period].present?
      @status=false
      @msg="not exist category or period params"
    else
      @token_user_id = params[:id]
      update_rank_point_table
    end

    if @status == true
      category = params[:category].to_i
      period = params[:period].to_i
      if !(category>0 && category<5) || !(period==1 || period==2)
        @status=false
        @msg="category or period error"
      end
    end

    if @status == true

      category = params[:category].to_i
      if category == 1
        category = "A"
      elsif category == 2
        category = "B"
      elsif category == 3
        category = "C"
      else
        category = "D"
      end

      if params[:period] == "2"
        #period = "mon_"
        period = "Mon"
        period_ = "mon_"
      else
        #period = "week_"
        period = "Week"
        period_ = "week_"
      end

      #tmp = "@ranker = RankingCurrent.order(\"" + period + category + " DESC\")"
      #eval(tmp)
      #
      tmp=[]
      p = "tmp = RankingTemp" + period + category + ".first(3)"
      eval(p)

      @prize=[]
      (0..2).each do |i|
        if tmp[i] != nil
          nickname = User.find_by_id(tmp[i].user_id).nickname
        else
          nickname = "짭짤이"
        end

        #if @ranker[i].present?
        #  nickname = User.find_by_id(@ranker[i].id).nickname
        #else
        #  nickname = nil
        #end
        temp = Prize.where('category = ? and period = ? and rank = ? and date_start <= ? and date_end >= ?',
                           params[:category].to_i, params[:period], i+1, Date.today, Date.today)
        if temp.present?
          tmp_hash = {:id => temp[0].id, :image => temp[0].image, :nickname => nickname, :content1 => temp[0].content1, :content2 => temp[0].content2, :content3 => temp[0].content3}
          @prize.push(tmp_hash)
        end
      end

      if !UserHighestLevel.find_by_user_id(params[:id]).present?
        new_data = UserHighestLevel.new
        new_data.user_id = params[:id].to_i
        new_data.category = 1
        new_data.stage = 1
        new_data.level = 1
        new_data.save
      end
      @my_level = UserHighestLevel.find_by_user_id(params[:id]).level
      my_rank=nil
      q = "my_rank = RankingTemp" + period + category + ".find_by_user_id(" + params[:id].to_s + ")"
      eval(q)
      if my_rank == nil
        @my_rank = 0
      else
        @my_rank = my_rank.id
      end
      @my_point=0
      r = "@my_point = RankingCurrent.find_by_id(params[:id])." + period_ + params[:category]
      eval(r)
      if tmp.size>0
        @remain_to1st = tmp[0].score - @my_point
      else
        @remain_to1st = 0
      end
      #@my_rank = @ranker.index{|r| r.id == params[:id].to_i} + 1
      @daily_test_count = user.daily_test_count

      #my_point_all = RankingCurrent.find_by_id(params[:id])
      #tmp = "@my_point = my_point_all." + period + category
      #eval(tmp)

      #tmp = "@remain_to1st = @ranker[0]." + period + category + ' - @my_point'
      #eval(tmp)

      @reward_today = RewardLog.where('user_id = ? and created_at >= ? and created_at < ? and reward > ?', user.id, Date.today.to_time, Date.tomorrow.to_time, 0).pluck(:reward).sum
      @reward_current = user.current_reward
      @reward_total = user.total_reward
      @character_url = user.character
    end
  end

  def get_prize_info
    @status=true
    @msg=""

    if !params[:id].present?
      @status=false
      @msg="not exist id params"
    else
      prize=Prize.find_by_id(params[:id])

      if !product.present?
        @status=false
        @msg="not exist prize"
      else
        @image = prize.image
        @content1 = prize.content1
        @content2 = prize.content2
        @content3 = prize.content3
      end
    end
  end


  def get_coupon_free_info
    @status=true
    @msg=""

    if !params[:id].present?
      @status=false
      @msg="not exist coupon_id params"
    else
      coupon=CouponFreeInfo.find_by_id(params[:id])

      if !coupon.present?
        @status=false
        @msg="not exist coupon"
      else
        @name = coupon.name
        @place = coupon.place
        @valid_start = coupon.valid_start
        @valid_end = coupon.valid_end
        @bar_code = coupon.bar_code
        @image = coupon.image
        @information = coupon.information
      end
    end
  end

  def get_maker_logo_url(cate_id)
    if cate_id=="SPCblah" || cate_id=="SPCaaaa"
      logo="happycon.jpg"
    else
      logo=cate_id + ".jpg"
    end
    return "http://www.todpop.co.kr/uploads/qpcon/logo/xhdpi/" + logo
  end

  def get_qpcon_info
    @status=true
    @msg=""

    if !params[:product_id] && !params[:order_id].present? 
      @status=false
      @msg="not exist product_id or order_id params"
    else

      if params[:product_id].present?

        coupon=QpconProduct.find_by_product_id(params[:product_id])

        if !coupon.present?
          @status=false
          @msg="not exist qpcon"
        else
          @category_id = nil
          @product_id = nil

          @name = coupon.product_name
          @maker = coupon.market_name
          @maker_logo_url = get_maker_logo_url(coupon.qpcon_category_id)
          @price = coupon.market_cost 

          @place = coupon.change_market_name
          @image = coupon.img_url_250
          @information = coupon.use_info
          @valid_duration = coupon.valid_date
          
          @valid_start = nil
          @valid_end = nil
          @bar_code = nil
          @veri_num = nil
          @admit_id = nil
          @is_used = nil
          @is_expired = nil
        end

      elsif params[:order_id].present?

        coupon=Order.find_by_order_id(params[:order_id])

        if !coupon.present?
          @status=false
          @msg="not exist ordered qpcon"
        else
          #qpcon_manager = QpconManager.new                          # pinStatus refresh 
          #qpcon_result = qpcon_manager.request_info_query(coupon)

          product = QpconProduct.find_by_product_id(coupon.product_id)

          if !product.present?
            @status=false
            @msg="not exist qpcon product"
          else
            #coupon=Order.find_by_order_id(params[:order_id])          # read again (for update safety, not mandatory)

            @category_id = product.qpcon_category_id
            @product_id = product.product_id

            @name = product.product_name
            @maker = product.market_name
            @maker_logo_url = get_maker_logo_url(product.qpcon_category_id)
            @price = product.market_cost 

            @place = product.change_market_name
            @image = product.img_url_250
            @information = product.use_info
            @valid_duration = nil

            @valid_start = nil
            @valid_end = coupon.limit_date
            @bar_code = coupon.barcode
            @veri_num = nil
            @admit_id = coupon.approval_number
            @is_used = coupon.is_used
            @is_expired = coupon.is_expired

            if @bar_code.include?("^")
              bar_split = @bar_code.split("^")
              @bar_code = bar_split[0]
              @veri_num = bar_split[1]
            end

          end
        end

      end


    end
  end




  def event_check
    @status=true
    @msg=""

    @user=User.find_by_id(params[:id])
    if !@user.present?
      @status=false
      @msg="not exist user"
    elsif params[:act]=='3001' && params[:value].present?          ##example act
      @msg = "this is act=3001 test"
      @value = params[:value]

      if params[:value]=="100"

        # reward
        @token_user_id = params[:id]
        @token_reward_type = 9999
        @token_title = "test title"
        @token_sub_title = "test sub"
        @token_reward = 9999
        process_reward_general

        # rank_point
        @token_user_id = params[:id]
        @token_point_type = 9999
        @token_name = "test name"
        @token_point = 9998
        process_point_general

      end

    else
      @msg = "enter proper act and value"
      @value = "99"
    end
  end




  def character
    @status=true
    @msg=""
    
    if !params[:id]
      @msg="not exist user_id"
    else
      user=User.find_by_id(params[:id])
      if params[:url]
        user.update_attributes(:character => params[:url])
      end
      @url=user.character
    end
  end

  def main_notice
    @status = true
    @msg = ""

    if params[:pro].present?
      @android_version = AppInfoPro.last.android_version
      @major_version = AppInfoPro.last.major_version
    elsif !AppInfo.last.android_version.present?
      @status = false
      @msg = "not exist android_version"
    #elsif !MentList.find_by_kind("notice").present?
    #  @status = false
    #  @msg = "not exist notice"
    else
      @android_version = AppInfo.first.android_version
      @store_state = AppInfo.first.store_open
      if MentList.find_by_kind("notice").present?
        mentlist = MentList.where(:kind => "notice")
        @ment = []
        @ment_arr = []
        (0..mentlist.count-1).each do |m|
          @ment_arr.push(:title=>mentlist[m].title, :content=>mentlist[m].content)
          @ment[m] = mentlist[m].content
        end
      end
    end
  end

  def user_count
    @count = User.all.count
  end
=begin
  def stage_initialization
    last_user = User.last.id
    log_count = UserStageBest.count
    (1..last_user).each do |i|
      if User.find_by_id(i).present?
        if !UserStageInfo.find_by_user_id(i).present?
          new_stage_info = UserStageInfo.new
          new_stage_info.user_id = i
          new_stage_info.stage_info = "Y"
          (1..1799).each do
            new_stage_info.stage_info += "x"
          end
          new_stage_info.save
        end
        if UserHighestLevel.find_by_user_id(i).present?
          high_level = UserHighestLevel.find_by_user_id(i)
          stage_info_user = UserStageInfo.find_by_user_id(i)
          stage_info_user.stage_info = "Y"
          (0..1799).each do
            stage_info_user.stage_info += "x"
          end
          (0..high_level.level-1).each do |j|
            stage_info_user.stage_info[j*10] = "Y"
          end
          stage_info_user.update_column(:stage_info, stage_info_user.stage_info)
        else
          ini_info_user = UserStageInfo.find_by_user_id(i)
          ini_info_user.stage_info[0] = "Y"
          ini_info_user.update_column(:stage_info, ini_info_user.stage_info)
        end
        if UserStageBest.find_by_user_id(i).present?
          stage_log = UserStageBest.where(:user_id => i)
          log_apply = UserStageInfo.find_by_user_id(i)
          (0..stage_log.count-1).each do |k|
            log_apply.stage_info[(stage_log[k].level.to_i-1)*10+(stage_log[k].stage.to_i-1)] = stage_log[k].n_medals_best.to_s
            if stage_log[k].n_medals_best >= 1
              log_apply.stage_info[(stage_log[k].level.to_i-1)*10+stage_log[k].stage.to_i] = "Y"
            end
          end
          log_apply.update_column(:stage_info, log_apply.stage_info)
        end
      end
    end
  end
=end
  def cpa_test
    @status = true
    @msg = ""

    int_mobile = params[:mobile].to_i

    if int_mobile%2 == 1
      @action_date = Date.today
      @action_time = "01:16:02"
    else
      @status = false
      @msg = "Not exist user"
    end
  end
 

=begin
  def launching

    @status = true
    @msg = ""
   
    @token_point = 300
    @token_name = "Launching Event"
    @token_point_type = 2500

    ActiveRecord::Base.connection.execute("TRUNCATE advertise_cpd_logs")
    ActiveRecord::Base.connection.execute("TRUNCATE advertise_cpdm_logs")
    ActiveRecord::Base.connection.execute("TRUNCATE advertise_cpx_logs")
    ActiveRecord::Base.connection.execute("TRUNCATE point_logs")
    ActiveRecord::Base.connection.execute("TRUNCATE ranking_histories")
    ActiveRecord::Base.connection.execute("TRUNCATE refund_requests")
    ActiveRecord::Base.connection.execute("TRUNCATE reward_logs")
    ActiveRecord::Base.connection.execute("TRUNCATE survey_results")
    ActiveRecord::Base.connection.execute("TRUNCATE user_highest_levels")
    ActiveRecord::Base.connection.execute("TRUNCATE user_stage_bests")
    ActiveRecord::Base.connection.execute("TRUNCATE user_stage_infos")
    ActiveRecord::Base.connection.execute("TRUNCATE user_test_histories")

    ranking_reset = RankingCurrent.all
    (0..ranking_reset.count-1).each do |i|
      if ranking_reset[i].present?
        ranking_reset[i].update_attributes(:week_1 => 0, :week_2 => 0, :week_3 => 0, :week_4 => 0, :mon_1 => 0, :mon_2 => 0, :mon_3 => 0, :mon_4 => 0)
      end
    end

    user_reset = User.all
    (0..user_reset.count-1).each do |j|
      if user_reset[j].present?
        user_reset[j].update_attributes(:level_test => 0, :daily_test_count => 0, :daily_test_reward => 0, :current_reward => 0, :total_reward => 0, :last_test => nil)
        @token_user_id = user_reset[j].id
        process_point_general
      end
    end




    ############## ad count reset (2013 12 13)  : change every time
    cpdmx_ad = CpdAdvertisement.all
    remain = 99999
    (0..cpdmx_ad.count-1).each do |j|
      if cpdmx_ad[j].present?
        cpdmx_ad[j].update_attributes(:remain => remain)
      end
    end

    cpdmx_ad = CpdmAdvertisement.all
    remain = 9999
    (0..cpdmx_ad.count-1).each do |j|
      if cpdmx_ad[j].present?
        cpdmx_ad[j].update_attributes(:remain => remain)
      end
    end

    cpdmx_ad = CpxAdvertisement.all
    remain = 9999
    (0..cpdmx_ad.count-1).each do |j|
      if cpdmx_ad[j].present?
        cpdmx_ad[j].update_attributes(:remain => remain)
      end
    end
    ################


  end
=end




  def show_user_stat
    @status = true
    @msg = ""


    # -------------------------- category stat

    n_basic=0
    n_middle=0
    n_high=0
    n_toeic=0

    ref_count = 3

    user_stage_infos = UserStageInfo.all
    (0..user_stage_infos.count-1).each do |j|
      if user_stage_infos[j].present?
        stage_basic=user_stage_infos[j].stage_info[0..149]
        stage_middle=user_stage_infos[j].stage_info[150..599]
        stage_high=user_stage_infos[j].stage_info[600..1199]
        stage_toeic=user_stage_infos[j].stage_info[1200..1799]

        stage_basic = stage_basic.gsub("x","")
        stage_basic = stage_basic.gsub("Y","")
        if stage_basic.size >= ref_count
          n_basic = n_basic+1
        end

        stage_middle = stage_middle.gsub("x","")
        stage_middle = stage_middle.gsub("Y","")
        if stage_middle.size >= ref_count
          n_middle = n_middle+1
        end

        stage_high = stage_high.gsub("x","")
        stage_high = stage_high.gsub("Y","")
        if stage_high.size >= ref_count
          n_high = n_high+1
        end

        stage_toeic = stage_toeic.gsub("x","")
        stage_toeic = stage_toeic.gsub("Y","")
        if stage_toeic.size >= ref_count
          n_toeic = n_toeic+1
        end
      end
    end

    @n_basic=n_basic
    @n_middle=n_middle
    @n_high=n_high
    @n_toeic=n_toeic


    # ---------------- age stat

    users = User.all
    n_age_1      = users.where('? <= birth and birth <= ?',Date.parse('2013-01-01'), Date.today).count
    n_age_2to7   = users.where('? <= birth and birth <= ?',Date.parse('2007-01-01'), Date.parse('2012-12-31')).count
    n_age_8to13  = users.where('? <= birth and birth <= ?',Date.parse('2001-01-01'), Date.parse('2006-12-31')).count
    n_age_14to16 = users.where('? <= birth and birth <= ?',Date.parse('1998-01-01'), Date.parse('2000-12-31')).count
    n_age_17to19 = users.where('? <= birth and birth <= ?',Date.parse('1995-01-01'), Date.parse('1997-12-31')).count
    n_age_20to24 = users.where('? <= birth and birth <= ?',Date.parse('1990-01-01'), Date.parse('1994-12-31')).count
    n_age_25to29 = users.where('? <= birth and birth <= ?',Date.parse('1985-01-01'), Date.parse('1989-12-31')).count
    n_age_30to39 = users.where('? <= birth and birth <= ?',Date.parse('1975-01-01'), Date.parse('1984-12-31')).count
    n_age_40to49 = users.where('? <= birth and birth <= ?',Date.parse('1965-01-01'), Date.parse('1974-12-31')).count
    n_age_50to59 = users.where('? <= birth and birth <= ?',Date.parse('1955-01-01'), Date.parse('1964-12-31')).count
    n_age_60to69 = users.where('? <= birth and birth <= ?',Date.parse('1945-01-01'), Date.parse('1954-12-31')).count
    n_age_70plus = users.where('birth <= ?',Date.parse('1944-12-31')).count

    


    @n_age=[]

    tmp_hash = {}
    tmp_hash[:age_1] = n_age_1
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_2to7] = n_age_2to7
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_8to13] = n_age_8to13
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_14to16] = n_age_14to16
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_17to19] = n_age_17to19
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_20to24] = n_age_20to24
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_25to29] = n_age_25to29
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_30to39] = n_age_30to39
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_40to49] = n_age_40to49
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_50to59] = n_age_50to59
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_60to69] = n_age_60to69
    @n_age.push(tmp_hash)

    tmp_hash = {}
    tmp_hash[:age_70plus] = n_age_70plus
    @n_age.push(tmp_hash)


    # ------------------- address stat

    address_head_all = Address.pluck(:depth1).uniq

    @n_address=[]
    (0..address_head_all.count-1).each do |j|
      tmp_hash={}
      n_person = User.where('address like ?',address_head_all[j] + "%").count
      @temp = 'tmp_hash[:' + address_head_all[j] + '] = ' + n_person.to_s
      eval(@temp)
      @n_address.push(tmp_hash)
    end

    # ------------------ DAU stat -----------------------------------------------------------------------

    if params[:mode]=="3"

      if params[:date].present?

        #start_date = User.find_by_id(1).created_at.to_date
        #end_date = Date.today
        user_all = User.all
        @dau=[]

        #(start_date..end_date).each do |d|

          d = params[:date].to_date

          n_user = User.where('created_at < ?', (d+1).to_time).count

          n_3=0
          n_2=0
          n_1=0
          tmp_hash={}

          user_all.each do |u|

            log_all = UserTestHistory.where('created_at >= ? and created_at < ? and user_id = ?', d.to_time, (d+1).to_time ,u.id).pluck(:level,:stage).uniq
            n_new=0
            log_all.each do |log|
              past = UserTestHistory.where('created_at < ? and user_id = ? and level = ? and stage = ?', d.to_time, u.id, log[0], log[1])
              if !past.present?
                n_new = n_new + 1
              end
            end

            if n_new==0
            elsif n_new==1
              n_1 = n_1 +1
            elsif n_new==2
              n_2 = n_2 +1
            else
              n_3 = n_3 +1
            end

          end

          tmp_hash[:date]=d
          tmp_hash[:users]=n_user
          tmp_hash[:n_3]=n_3
          tmp_hash[:n_2]=n_2
          tmp_hash[:n_1]=n_1

          @dau.push(tmp_hash)

        #end

      end

    end


    # ---------------------------------------------


  end


  def show_service_stat
    @status = true
    @msg = ""

    total_reward_active = User.all.pluck(:total_reward).sum
    total_reward_inactive = InactiveUser.all.pluck(:total_reward).sum

    @total_reward_amount = total_reward_active + total_reward_inactive

  end

  # ----------------------------------------------------------------------------------------------------------

  # cys user_analytics

  def user_anal
    @status = true
    @msg = ""

    @date_start = (Date.today - 7.day).beginning_of_week
    @date_end   = (Date.today - 7.day).end_of_week
    @now = Time.now
    @time_start = @date_start.to_time
    @time_end = (@date_end+1.day).to_time

    user = User.find_by_id(params[:user_id])
    category = params[:category].to_i

    #@date_start = (Date.today - 42.day).beginning_of_week
    #@date_end   = (Date.today - 42.day).end_of_week
    #@time_start = @date_start.to_time
    #@time_end = (@date_end+1.day).to_time
    #user = User.find_by_id('2749')
    #category = 2



    @user_id = user.id
    @nickname = user.nickname
    @sex = user.sex
    @birth = user.birth
    @level = user.level_test

    @reg_date = user.created_at
    @last_test_date = user.last_test
    @daily_test_count = user.daily_test_count

    @total_reward = user.total_reward
    @daily_test_reward = user.daily_test_reward

    @days = (Date.today - @reg_date.to_date + 1).to_i
    @n_total_log_wp = PointLog.where('user_id=?',@user_id).count
    @n_total_log_wop = UserTestHistory.where('user_id=? and rank_point=0',@user_id).count
    @n_period_log_wp = PointLog.where('user_id=? and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_log_wop = UserTestHistory.where('user_id=? and rank_point=0 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @point_string = ((700.0/@days).round(1)).to_s + '% days, ' + ((@n_period_log_wp.to_f*100/@n_total_log_wp).round(1)).to_s + ' % point logs, ' + (((@n_period_log_wp+@n_period_log_wop).to_f*100/(@n_total_log_wp+@n_total_log_wop)).round(1)).to_s + ' % point logs (including 0s)'

    @n_period_1_log_wp  =        PointLog.where('user_id=? and point_type=1001 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_1_log_wop = UserTestHistory.where('user_id=? and      category=1 and rank_point=0 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_2_log_wp  =        PointLog.where('user_id=? and point_type=1002 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_2_log_wop = UserTestHistory.where('user_id=? and      category=2 and rank_point=0 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_3_log_wp  =        PointLog.where('user_id=? and point_type=1003 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_3_log_wop = UserTestHistory.where('user_id=? and      category=3 and rank_point=0 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_4_log_wp  =        PointLog.where('user_id=? and point_type=1004 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @n_period_4_log_wop = UserTestHistory.where('user_id=? and      category=4 and rank_point=0 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count

    @n_period_x_log = PointLog.where('user_id=? and point_type!=1001 and point_type!=1002 and point_type!=1003 and point_type!=1004 and point_type!=2000 and point_type!=2500 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).count
    @period_x_log = PointLog.where('user_id=? and point_type!=1001 and point_type!=1002 and point_type!=1003 and point_type!=1004 and point_type!=2000 and point_type!=2500 and created_at>=? and created_at<?',@user_id,@time_start,@time_end)

    @point_period = PointLog.where('user_id=? and created_at>=? and created_at<?',@user_id,@time_start,@time_end).pluck(:point).sum
    @point_1_period = PointLog.where('user_id=? and point_type!=1002  and point_type!=1003 and point_type!=1004 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).pluck(:point).sum
    @point_2_period = PointLog.where('user_id=? and point_type!=1001  and point_type!=1003 and point_type!=1004 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).pluck(:point).sum
    @point_3_period = PointLog.where('user_id=? and point_type!=1001  and point_type!=1002 and point_type!=1004 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).pluck(:point).sum
    @point_4_period = PointLog.where('user_id=? and point_type!=1001  and point_type!=1002 and point_type!=1003 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).pluck(:point).sum

    if category==1
      @win_point=@point_1_period
    elsif category==2
      @win_point=@point_2_period
    elsif category==3
      @win_point=@point_3_period
    elsif category==4
      @win_point=@point_4_period
    end

    #cnt=0
    @n_new_study=0
    @new_study_point=0
    @n_re_study=0
    @re_study_point=0
    study_all = UserTestHistory.where('user_id=? and category=? and created_at>=? and created_at<?',@user_id,category,@time_start,@time_end)
    study_all.each do |s|
      #cnt+=1
      #puts(cnt)
      past = UserTestHistory.where('user_id=? and category=? and level=? and stage=? and created_at<?',@user_id,category,s.level,s.stage,s.created_at)
      if !past.present?
        @n_new_study += 1
        @new_study_point += s.rank_point
      else
        @n_re_study += 1
        @re_study_point += s.rank_point
      end
    end
    @study_point = @new_study_point + @re_study_point
    @new_study_point_string = @new_study_point.to_s + '(' + (@new_study_point.to_f*100/@win_point).round(1).to_s    + ' %)'
    @re_study_point_string = @re_study_point.to_s + '(' + (@re_study_point.to_f*100/@win_point).round(1).to_s    + ' %)'
    @study_point_string = @study_point.to_s + '(' + (@study_point.to_f*100/@win_point).round(1).to_s    + ' %)'

    @daily_test_point = PointLog.where('user_id=? and point_type=2000 and created_at>=? and created_at<?',@user_id,@time_start,@time_end).pluck(:point).sum
    @daily_test_point_string = @daily_test_point.to_s + '(' + (@daily_test_point.to_f*100/@win_point).round(1).to_s    + ' %)'

    @cp_point = @period_x_log.pluck(:point).sum
    @cp_point_string = @cp_point.to_s + '(' + (@cp_point.to_f*100/@win_point).round(1).to_s    + ' %)'

    @non_study_point = @daily_test_point + @cp_point
    @non_study_point_string = @non_study_point.to_s + '(' + (@non_study_point.to_f*100/@win_point).round(1).to_s    + ' %)'

  end





  # ----------------------------------------------------------------------------------------------------------



end








