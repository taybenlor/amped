class LikesController < ApplicationController
  # GET /likes
  # GET /likes.xml
  def index
    @likes = Like.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @likes }
    end
  end

  # GET /likes/1
  # GET /likes/1.xml
  def show
    @like = Like.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @like }
    end
  end

  # GET /likes/new
  # GET /likes/new.xml
  def new
    @like = Like.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @like }
    end
  end

  # GET /likes/1/edit
  def edit
    @like = Like.find(params[:id])
  end

  # POST /likes
  # POST /likes.xml
  def create
    @like = Like.new(params[:like])

    respond_to do |format|
      if @like.save
        format.html { redirect_to(@like, :notice => 'Like was successfully created.') }
        format.xml  { render :xml => @like, :status => :created, :location => @like }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @like.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /likes/1
  # PUT /likes/1.xml
  def update
    @like = Like.find(params[:id])

    respond_to do |format|
      if @like.update_attributes(params[:like])
        format.html { redirect_to(@like, :notice => 'Like was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @like.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.xml
  def destroy
    @like = Like.find(params[:id])
    @like.destroy

    respond_to do |format|
      format.html { redirect_to(likes_url) }
      format.xml  { head :ok }
    end
  end
end
