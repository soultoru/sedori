class ProductsController < ApplicationController
  #before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    check_login
    @keyword = params[:keyword]
    redirect_to root_path if @keyword.blank?
    #@keyword = @keyword.split(' ')

    #client = MWS.products
    client = MWS::Products::Client.new(mws_access_keys(current_user))

    begin
      if @keyword =~ /\d{8}/ || @keyword =~ /\d{11}/
        res = client.get_matching_product_for_id('JAN',@keyword)
      elsif @keyword =~ /[a-zA-Z0-9]{10}/
        res = client.get_matching_product_for_id('ASIN',@keyword)
      elsif @keyword =~ /\d{13}/
        res = client.get_matching_product_for_id('ISBN',@keyword)
      else
        res = client.list_matching_products("Query=#{@keyword}")
      end
    rescue
    end

    if res.present?
      doc = Nokogiri::XML.parse(res.body)
      @products = Hash.from_xml(doc.to_xml)['ListMatchingProductsResponse']['ListMatchingProductsResult']['Products']['Product']
    end
    @products ||= []
  end

=begin
  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params[:product]
    end
=end
end
