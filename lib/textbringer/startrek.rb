require "net/http"

define_command :startrek, doc: "Play a Star Trek animation file" do
  buffer = Buffer.find_or_new("*startrek*", undo_limit: 0,
                              read_only: true)
  switch_to_buffer(buffer)
  buffer.read_only_edit do
    buffer.replace("")
  end
  message("Loading...")
  background do
    s = Net::HTTP.get(URI("http://artscene.textfiles.com/vt100/startrek.vt"))
    frames = s.sub(/\A\e\[H\e\[J\n/, "").split(/\e\[H\n/)
    foreground do
      message("")
    end
    frames.each do |frame|
      foreground do
        buffer.read_only_edit do
          buffer.replace(frame)
        end
      end
      sleep(0.1)
    end
    foreground do
      message("END")
    end
  end
end
