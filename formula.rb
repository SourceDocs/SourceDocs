class SourceDocs < Formula
  desc "Command Line Tool written in Swift that generates Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  version "0.1.0"
  url "https://github.com/eneko/SourceDocs/archive/#{version}.tar.gz"
  sha256 "d908ce6d8fb6f61ac42b802a67b9f5a25b77fdfa21f3878bac4478b62dc4d8ff"
  head "https://github.com/eneko/SourceDocs.git"

  depends_on :xcode

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
