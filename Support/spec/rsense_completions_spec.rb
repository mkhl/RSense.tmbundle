require "#{File.dirname(__FILE__)}/../lib/rsense_completions"

describe RSenseCompletions do
  it "should compute correct column for method completion when method is empty" do
    input = '"hi".'
    rc = RSenseCompletions.new(5, 1, input)
    rc.prefix.should == ''
    rc.column.should == 4
  end

  it "should not compute completions when no . occurs on current line" do
    input = 'foo("a")'
    rc = RSenseCompletions.new(8, 1, input)
    rc.prefix.should == input
    rc.column.should == 0
  end
  
  it "should determine method prefix" do
    input = 'op'
    rc = RSenseCompletions.new(2, 1, input)
    rc.prefix.should == input
    rc.column.should == 0
  end

  it "should determine method prefix with whitespace" do
    input = '  op'
    rc = RSenseCompletions.new(4, 1, input)
    rc.prefix.should == 'op'
    rc.column.should == 0
  end

  it "should compute correct column for method completion when method has prefix" do
    input = '"hi".ea'
    rc = RSenseCompletions.new(7, 1, input)
    rc.prefix.should == 'ea'
    rc.column.should == 4
  end
  
  it "should parse rsense completions" do
    completions = "completion: to_enum Object#to_enum\ncompletion: succ! String#succ!"
    rc = RSenseCompletions.new
    rc.stub!(:rsense_completions).and_return(completions)
    rc.stub!(:prefix).and_return(nil)
    
    rc.completion_list.should == [["to_enum", "Object#to_enum"], ["succ!", "String#succ!"]].sort
  end

  it "should select completions using prefix" do
    completions = "completion: to_enum Object#to_enum\ncompletion: succ! String#succ!"
    rc = RSenseCompletions.new
    rc.stub!(:rsense_completions).and_return(completions)
    rc.stub!(:prefix).and_return("s")
    
    rc.completion_list.should == [["succ!", "String#succ!"]]
  end
end
