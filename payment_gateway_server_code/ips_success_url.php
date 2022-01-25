<!DOCTYPE html>
<html>
<head>
	<title></title>

	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
		<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
</head>
<body>
		<div class="container">
		    
		    <?php if($_REQUEST['TXNID'] != null) : ?>
    <h3>Thank you for joining with us. Your payment has been successful.</h3>

<?php else : ?>
   <h3>Sorry! Transaction failed...</h3>
<?php endif; ?>

		
		<?php header('refresh:10; URL= https://jobpauchha.com'); ?>
		</div>

</body>
</html>