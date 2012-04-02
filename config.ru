app = proc do |env|
    [200, { 'Content-Type' => 'text/html' }, ['This website is being upgraded.']]
end

run app
