class MeetingsController < ApplicationController
  require_role "admin", :except => [ :index, :show, :next_scheduled ]
  before_filter :load_upcoming, :only => [ :index, :next_scheduled ]

  # GET /meetings
  # GET /meetings.xml
  def index
    @meetings = Meeting.recent_past

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @meetings }
    end
  end

  # GET /meetings/1
  # GET /meetings/1.xml
  def show
    @meeting = Meeting.find(params[:id]) unless params[:id] == "0"
    @attendee = @meeting.attendee_with_user(current_user) || Attendee.new if @meeting

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/new
  # GET /meetings/new.xml
  def new
    @meeting = Meeting.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meeting }
    end
  end

  # GET /meetings/1/edit
  def edit
    @meeting = Meeting.find(params[:id])
  end

  # POST /meetings
  # POST /meetings.xml
  def create
    @meeting = Meeting.new(params[:meeting])

    respond_to do |format|
      if @meeting.save
        flash[:notice] = 'Meeting was successfully created.'
        format.html { redirect_to(@meeting) }
        format.xml  { render :xml => @meeting, :status => :created, :location => @meeting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /meetings/1
  # PUT /meetings/1.xml
  def update
    @meeting = Meeting.find(params[:id])

    respond_to do |format|
      if @meeting.update_attributes(params[:meeting])
        flash[:notice] = 'Meeting was successfully updated.'
        format.html { redirect_to(@meeting) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meeting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.xml
  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy

    respond_to do |format|
      format.html { redirect_to(meetings_url) }
      format.xml  { head :ok }
    end
  end

  # GET /meetings/next_scheduled
  def next_scheduled
    @meetings = Meeting.next_scheduled
    @meeting = @meetings[0]
    @attendee = @meeting.attendee_with_user(current_user) || Attendee.new if @meeting

    respond_to do |format|
      if @meeting
        format.html { render :action => "show" }
        format.xml  { render :xml => @meeting }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => [] }
      end
    end
  end

  protected

  def load_upcoming
    if logged_in? && current_user.admin?
      @upcoming_meetings = Meeting.upcoming
    end
  end
end
