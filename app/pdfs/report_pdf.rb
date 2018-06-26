class ReportPdf < Prawn::Document

  require "prawn/measurement_extensions"

  def initialize(request, request_items, report, report_items)
    super(page_size: "A4", page_layout: :landscape)

    font_size(10)
    font "vendor/fonts/ipaexg.ttf"
    @page_size = 1
    @current_page = 1

    @l_org_x = 0
    @r_org_x = bounds.width / 2
    @l_end_x = bounds.width / 2
    @r_end_x = bounds.width

    @org_y = bounds.height
    @header_h = 80
    header_w = bounds.width / 2

    default_leading 5

    # request header
    title = "営業出張申請"
    sales = request.name
    if request.auth_id.nil?
      auth = "---"
    else
      auth = User.find(request.auth_id).name
    end
    date = request.req_date
    region = request.region
    p_start = request.start
    p_end = request.end
    @position = []
    @position[0] = @l_org_x
    @position[1] = @org_y

    # dawing left header
    header(title, sales, auth, date, region, p_start, p_end, @position, @header_h, header_w)


    title = "営業出張報告"
    sales = request.name # assuming that the same as request
    if report.auth_id.nil?
      auth = "---"
    else
      auth = User.find(report.auth_id).name
    end
    date = report.rep_date
    region = report.region
    p_start = report.start
    p_end = report.end
    @position[0] = @r_org_x
    @position[1] = @org_y

    #default_leading 5

    # dawing right header
    header(title, sales, auth, date, region, p_start, p_end, @position, @header_h, header_w)

    # drawing left body
    @body_margin = 5
    @position[0] = @l_org_x + @body_margin
    @position[1] = @org_y - @header_h - @body_margin

    request_items.each do |item|
      body(item.place, item.visit, item.personnel, item.purpose,
            item.notes, item.comment, 1, header_w, @body_margin, :left, @l_end_x)
    end
    stroke do
      vertical_line @position[1] + @body_margin , @org_y, at: @r_org_x
    end

    bounding_box([0, bounds.height], width: bounds.width, height: bounds.height) do
      stroke_bounds
    end

# drawing right body
    @current_page = 1
    go_to_page(@current_page)
    @body_margin = 5
    @position[0] = @r_org_x + @body_margin
    @position[1] = @org_y - @header_h - @body_margin

    report_items.each do |item|
      body(item.place, item.visit, item.personnel, item.information,
            item.notes, item.comment, 1, header_w, @body_margin, :right, @r_end_x)
    end
    stroke do
      vertical_line @position[1] + @body_margin , @org_y, at: @r_org_x
    end

    bounding_box([0, bounds.height], width: bounds.width, height: bounds.height) do
      stroke_bounds
    end

    paging

  end

  ##########################################################################################

  def header(title, sales, auth, date, region, p_start, p_end, position, h, w)

    bounding_box(position, width: w, height: h) do
      margin = 5
      in_pos = []
      in_pos[0] =  margin
      in_pos[1] = h - margin
      in_h = h - margin * 2
      in_w = w - margin * 2
      bounding_box(in_pos, width: in_w, height: in_h) do
        y = cursor
        text title, size: 14
        move_cursor_to y
        text "申請日：#{date.strftime("%Y/%m/%d")}", align: :right
        dw = width_of "申請日：#{date.strftime("%Y/%m/%d")}"
        pos = []
        pos[0] = in_w - dw
        pos[1] =  cursor - 10
        draw_text "営業：    #{sales}", at: pos
        pos[1] =  cursor - 25
        draw_text "承認：    #{auth}", at: pos

        text "方面：#{region}<br>" + 
             "期間：#{p_start.strftime("%Y/%m/%d")}〜#{p_end.strftime("%Y/%m/%d")}", 
             inline_format: true, valign: :bottom, leading: 5
      end
      stroke_bounds
    end
  end

  def body(place, visit, personnel, contents, notes, comment, h, w, margin, orient, x_end)
    
    box_h = height_of "地区：#{place}　訪問先：#{visit}　面談者：#{personnel}", width: w - margin 
    going_to_new_page(box_h, orient)
    text_box "地区：#{place}　訪問先：#{visit}　面談者：#{personnel}", at: @position, height: h, width: w - margin, overflow: :expand
    @position[1] -= box_h

    going_to_new_page(margin, orient)
    lw = line_width
    line_width 0.1
    stroke do
      horizontal_line @position[0]-margin, x_end, at: @position[1]
    end
    line_width lw
    @position[1] -= margin

    box_h = height_of contents, width: w - margin
    going_to_new_page(box_h, orient)
    text_box contents, at: @position, height: h, width: w - margin, overflow: :expand
    @position[1] -= box_h

    if notes.present?
      box_h = height_of "【特記】#{notes}", width: w - margin
      going_to_new_page(box_h, orient)
      text_box "【特記】#{notes}", at: @position, height: h, width: w - margin, overflow: :expand
      @position[1] -= box_h
    end
    if comment.present?
      box_h = height_of "【コメント】#{comment}", width: w - margin
      going_to_new_page(box_h, orient)
      text_box "【コメント】#{comment}", at: @position, height: h, width: w - margin, overflow: :expand
      @position[1] -= box_h
    end
#binding.pry
    # draw pertion line
    stroke do
      # @position[1] -= margin
      horizontal_line @position[0]-margin, x_end, at: @position[1]
    end
    @position[1] -= margin #* 2 # one for line and one for self-margin
  end

  def init_new_page(portion)
    if portion == :left
      @position[0] = @l_org_x + @body_margin
    else
      @position[0] = bounds.width / 2 + @body_margin
    end
    @position[1] = @org_y - @body_margin
  end

  def going_to_new_page(h, portion)
    if @position[1] < h

      if portion == :left
        bounding_box([0, bounds.height], width: bounds.width, height: bounds.height) do
          stroke_bounds
        end
      else
        stroke do
          vertical_line 0, @org_y, at: @r_org_x
        end
      end

      if @page_size > @current_page
        @current_page += 1
        go_to_page(@current_page)
      else
        # left side is shorter that need to draw vertical line all the way
        stroke do
          vertical_line 0, @org_y, at: @r_org_x
        end
        start_new_page
        @page_size += 1
        @current_page += 1
      end
      init_new_page(portion)
    end
  end

  def paging
    count = 1
    @page_size.times do
      go_to_page(count)
      stroke do
        bounding_box [0, -10], width: @r_end_x, height: 10 do
          text "- #{count}/#{@page_size} -", align: :center
        end
      end
      count += 1
    end
  end

end