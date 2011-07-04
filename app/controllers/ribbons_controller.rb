class RibbonsController < ApplicationController
  # require_role "admin", :for => [:new, :create, :update, :destroy]
  # GET /ribbons
  # GET /ribbons.xml
  def index
    ribbons = Ribbon
    ribbons.where("level is not true")
    ribbons.where("level is true") if params[:level] == "true"
    @ribbons = ribbons.order("name").paginate(:page => params[:page], :per_page => 25)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ribbons }
    end
  end

  # GET /ribbons/1
  # GET /ribbons/1.xml
  def show
    @ribbon = Ribbon.find(params[:id])
   @commentable = @ribbon
    @comments = @commentable.comments

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ribbon }
    end
  end

  # GET /ribbons/new
  # GET /ribbons/new.xml
  def new
    @ribbon = Ribbon.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ribbon }
    end
  end

  # GET /ribbons/1/edit
  def edit
    @ribbon = Ribbon.find(params[:id])
  end

  # POST /ribbons
  # POST /ribbons.xml
  def create
    @ribbon = Ribbon.new(params[:ribbon])

    respond_to do |format|
      if @ribbon.save
        flash[:notice] = 'Ribbon was successfully created.'
        format.html { redirect_to(@ribbon) }
        format.xml  { render :xml => @ribbon, :status => :created, :location => @ribbon }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ribbon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ribbons/1
  # PUT /ribbons/1.xml
  def update
    @ribbon = Ribbon.find(params[:id])

    respond_to do |format|
      if @ribbon.update_attributes(params[:ribbon])
        flash[:notice] = 'Ribbon was successfully updated.'
        format.html { redirect_to(@ribbon) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ribbon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ribbons/1
  # DELETE /ribbons/1.xml
  def destroy
    @ribbon = Ribbon.find(params[:id])
    @ribbon.destroy

    respond_to do |format|
      format.html { redirect_to(ribbons_url) }
      format.xml  { head :ok }
    end
  end
end
