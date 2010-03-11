atom_feed do |feed|
  feed.title("CocoaHeads Atlanta Meetings")
  feed.updated(Time.now)

  @meetings.each do |meeting|
    feed.entry(meeting) do |entry|
      entry.title(meeting.title)
      entry.content(feed_summary(meeting))

      entry.author do |author|
        author.name("CHAtl")
      end
    end
  end
end
