require 'anemone'
require 'nokogiri'
require 'kconv'

date = ARGV[0]
NPB_SCHEDULE = "https://baseball.yahoo.co.jp/npb/schedule/?&date=#{date}"

Anemone.crawl(NPB_SCHEDULE, depth_limit: 1) do |ae|
  ae.on_every_page do |page|
    doc = Nokogiri::HTML.parse(page.body.toutf8)
    doc.xpath('//table[@class="yjMS mb5"]/tr').each do |node|

      # team
      node.xpath('td[@class="today pl7"]/a').each do |elem|
        p elem.text
      end

      # startTime ballPark
      node.xpath('td[@class="today pl7"]/em').each do |elem|
        /(\d{2}:\d{2})(.+)/ =~ elem.text
        p $1
        p $2.gsub(" ", "")
      end

      # score inning
      node.xpath('td[@class="today ct"]').each do |elem|
        if /(\d+) - (\d+)/ =~ elem.text
          p $1
          p $2
          p elem.text
        end

        elem.xpath('a').each do |inning|
          p inning.text
        end
      end

      # pitchers
      node.xpath('td[@class="today"]/table/tr').each do |elem|
        p elem.xpath('td[@class="w"]').text.gsub(/勝[[:space:]]/,"")
        p elem.xpath('td[@class="s"]').text.gsub(/S[[:space:]]/,"")
        p elem.xpath('td[@class="l"]').text.gsub(/敗[[:space:]]/,"")
      end

    end
  end
end

