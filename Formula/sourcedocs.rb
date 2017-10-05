class SourceDocs < Formula
  desc "Command Line Tool written in Swift that generates Markdown files from inline source code documentation"
  homepage "https://github.com/eneko/SourceDocs"
  version "0.1.0"
  url "https://github.com/eneko/SourceDocs/archive/#{version}.tar.gz"
  sha256 "d908ce6d8fb6f61ac42b802a67b9f5a25b77fdfa21f3878bac4478b62dc4d8ff"
  head "https://github.com/eneko/SourceDocs.git"

  depends_on :xcode

  # def install
  #   system "make", "install", "PREFIX=#{prefix}"
  # end
  def install
    build_path = "#{buildpath}/.build/release/sourcedocs"
    ohai "Building SourceDocs"
    system("swift --disable-sandbox build -c release -Xswiftc -static-stdlib")
    bin.install build_path
  end
end
