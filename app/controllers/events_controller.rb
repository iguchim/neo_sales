class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where(start: params[:start]..params[:end])

    add_request_events

    #binding.pry
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.save
  end

  def update
    @event.update(event_params)
  end

  def destroy
    @event.destroy
  end

  def seluser
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      #params.require(:event).permit(:title, :date_range, :start, :end, :color, :kind, :user_id)
      params.require(:event).permit(:title, :date_range, :start, :end, :color, :user_id)

    end

    def add_request_events

      requests = Request.where(start: params[:start]..params[:end])
      @events = @events.to_a

      requests.each do |request|
        event = Event.new
        event.id = request.id # cheating---let go to request when event clicked on calendar
        event.user_id = request.user_id
        event.title = request.region
        event.start = request.start
        event.end = request.end
        event.color = User.find(request.user_id).color
        event.kind = 'request'
        @events << event
      end

      refd_users = referred_users

      evs = []
      @events.each do |event|
        if refd_users.include?(event.user_id)
          evs << event
        end
      end

      @events = evs

    end

    def referred_users
      user_ids = []
      ReferenceUser.all.each do |ref|
        user_ids << ref.referred_id if ref.refer_id == current_user.id
      end
      user_ids
    end
end
