<?php
	$name = file_get_contents('name.txt');
?>
<!doctype html>
<html>
	<head>
		<link rel="icon" type="image/ico" href="favicon.ico">
		<title>[<?php echo $name;?>]</title>
		<style>
			#wrapper{
				margin-right: auto;
				margin-left: auto;
				width: 500px;
			}
		</style>
	</head>
	<body>
		<div id="wrapper">
			<h1>[<?php echo $name;?>] Repo Installation:</h1>
			Append this to /etc/pacman.conf
			<pre><?php echo file_get_contents('config.txt');?></pre>
			<?php
				$db = scandir('phar://'.getcwd().'/x86_64/omni.db');
				$dir1 = scandir(getcwd().'/i686');
				$dir2 = scandir(getcwd().'/x86_64');
				foreach($db as $file) {
					$desc = file_get_contents('phar://'.getcwd().'/x86_64/omni.db/'.$file.'/desc');
					$desc = substr($desc,strrpos($desc,'%DESC%')+7,strlen($desc)-strrpos($desc,'%DESC%')-(strlen($desc)-strpos($desc,'%CSIZE%'))-7);
					echo "<h2>$file</h2><p><h4>{$desc}</h4> :: Downloads<br/>";
					echo " => <a href='i686/$file-i686.pkg.tar.xz'>i686</a><br/>";
					echo " => <a href='x86_64/$file-x86-64.pkg.tar.xz'>x86_64</a><br/>";
					echo "</p>";
				}
			?>
		</div>
	</body>
</html>