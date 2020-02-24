# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'Firebase/Analytics'
	pod 'Firebase/Auth'
	pod 'Firebase/Database'
	pod 'MarqueeLabel'
end

target 'Shortlist' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Shortlist
#  pod 'Firebase/Analytics'
#  pod 'Firebase/Auth'
#  pod 'Firebase/Database'
#  pod 'MarqueeLabel'

	shared_pods

  target 'ShortlistTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ShortlistUITests' do
    inherit! :search_paths
	shared_pods
  end

end

target 'Shortlist WatchKit App' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Shortlist WatchKit App

end

target 'Shortlist WatchKit Extension' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Shortlist WatchKit Extension

end
