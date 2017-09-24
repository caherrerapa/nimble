class KeywordsController < ApplicationController
  before_action :set_keyword, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /keywords
  # GET /keywords.json
  def index
    @keywords = Keyword.all
  end

  class Adwords
    def initialize(title,url, links)
      @title = title
      @url = url
      @links = links
    end
    attr_reader :title
    attr_reader :url
    attr_reader :links
  end

  class Links
    def initialize(total)
      @total = total
    end
    attr_reader :total
  end
  # GET /keywords/1
  # GET /keywords/1.json
  def show
    require 'open-uri'
    keyword = @keyword.word
    doc = Nokogiri::HTML(open("https://www.google.co.th/search?q=#{keyword}", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

    @total = []
    total_links = doc.css('#resultStats')
      total = total_links.text
    @total << Links.new(total)


    @top_adwords_array = []
    top_adwords = doc.css('#center_col li.ads-ad')
    top_adwords.each do |adwords|
      title = adwords.css('h3').first.text
      url = adwords.css('cite').first.text
      links = total_links
      @top_adwords_array << Adwords.new(title, url,links)
    end

    @right_adwords_array = []
    adwords_right = doc.css('#rhs_block li.ads-ad')
    adwords_right.each do |radwords|
      title = radwords.css('h3').first.text
      url = radwords.css('cite').first.text
      links = total_links
      @right_adwords_array << Adwords.new(title, url,links)
    end

    @non_adwords_array = []
    non_adwords = doc.css('#search .g')
    non_adwords.each do |nonadword|
      title = nonadword.css('a').first.text
      url = nonadword.css('cite').text
      links = total_links
      @non_adwords_array << Adwords.new(title, url, links)
    end
  end



  def results_page #this isnt used anymore but i used this for checking how to use nokogiri
    require 'open-uri'
    doc = Nokogiri::HTML(open("https://www.google.co.th/search?q=bangkok+hotels", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

    # html = doc.read

    total_links = doc.css('#resultStats').text
    # total_links.read


    @top_adwords_array = []
    top_adwords = doc.css('#center_col li.ads-ad')
    top_adwords.each do |adwords|
      title = adwords.css('h3').first.text
      url = adwords.css('cite').first.text
      links = total_links
      @top_adwords_array << Adwords.new(title, url,links)
    end

    @right_adwords_array = []
    adwords_right = doc.css('#rhs_block li.ads-ad')
    adwords_right.each do |radwords|
      title = radwords.css('h3').first.text
      url = radwords.css('cite').first.text
      links = total_links
      @right_adwords_array << Adwords.new(title, url,links)
    end

    @non_adwords_array = []
    non_adwords = doc.css('#search .g')
    non_adwords.each do |nonadword|
      title = nonadword.css('a').first.text
      url = nonadword.css('cite').text
      links = total_links
      @non_adwords_array << Adwords.new(title, url, links)
    end

    render template: 'Adwords'
  end



  # GET /keywords/new
  def new
    @keyword = Keyword.new
  end

  # GET /keywords/1/edit
  def edit
  end

  def import
    @user = current_user
    Keyword.import(params[:file], @user)
    redirect_to root_url, notice: "Keywords imported."
  end

  def
  # POST /keywords
  # POST /keywords.json
  def create
    @user = current_user
    @keyword = @user.Keyword.new(keyword_params)

    respond_to do |format|
      if @keyword.save
        format.html { redirect_to @keyword, notice: 'Keyword was successfully created.' }
        format.json { render :show, status: :created, location: @keyword }
      else
        format.html { render :new }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /keywords/1
  # PATCH/PUT /keywords/1.json
  def update
    respond_to do |format|
      if @keyword.update(keyword_params)
        format.html { redirect_to @keyword, notice: 'Keyword was successfully updated.' }
        format.json { render :show, status: :ok, location: @keyword }
      else
        format.html { render :edit }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.json
  def destroy
    @keyword.destroy
    respond_to do |format|
      format.html { redirect_to keywords_url, notice: 'Keyword was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyword
      @keyword = Keyword.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def keyword_params
      params.require(:keyword).permit(:word, :user_id)
    end
end
