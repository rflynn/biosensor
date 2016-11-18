'''
given a set of images and annotations in ../vid-tag/$tag/...
    use the annotations to produce a set of cropped images in ../vid-tag-cropped/$tag/
'''

'''
$ cat ../vid-tag/cardinalis-cardinalis/2016-10-17-16-51-03.xml
<?xml version="1.0" ?>
<annotation>
	<folder>cardinalis-cardinalis</folder>
	<filename>2016-10-17-16-51-03</filename>
	<path>/Users/ryanflynn/src/biosensor/vid-tag/cardinalis-cardinalis/2016-10-17-16-51-03.jpg</path>
	<source>
		<database>Unknown</database>
	</source>
	<size>
		<width>512</width>
		<height>384</height>
		<depth>3</depth>
	</size>
	<segmented>0</segmented>
	<object>
		<name>cardinalis-cardinalis</name>
		<pose>Unspecified</pose>
		<truncated>0</truncated>
		<difficult>0</difficult>
		<bndbox>
			<xmin>406</xmin>
			<ymin>316</ymin>
			<xmax>436</xmax>
			<ymax>342</ymax>
		</bndbox>
	</object>
	<object>
		<name>sciurus-carolinensis</name>
		<pose>Unspecified</pose>
		<truncated>0</truncated>
		<difficult>0</difficult>
		<bndbox>
			<xmin>143</xmin>
			<ymin>253</ymin>
			<xmax>187</xmax>
			<ymax>343</ymax>
		</bndbox>
	</object>
	<object>
		<name>passer-domesticus</name>
		<pose>Unspecified</pose>
		<truncated>0</truncated>
		<difficult>0</difficult>
		<bndbox>
			<xmin>192</xmin>
			<ymin>133</ymin>
			<xmax>205</xmax>
			<ymax>167</ymax>
		</bndbox>
	</object>
	<object>
		<name>passer-domesticus</name>
		<pose>Unspecified</pose>
		<truncated>0</truncated>
		<difficult>0</difficult>
		<bndbox>
			<xmin>204</xmin>
			<ymin>107</ymin>
			<xmax>225</xmax>
			<ymax>122</ymax>
		</bndbox>
	</object>
</annotation>
'''

import os

from PIL import Image
import xml.etree.ElementTree as ET




def crop_file(filepath, xmin, ymin, xmax, ymax):
    img = Image.open(filepath)
    return img.crop((xmin, ymin, xmax, ymax))


def process_annotation_file(filepath):
    tree = ET.parse(filepath)
    root = tree.getroot()
    imgpath = root.find('./path').text
    filename = root.find('./filename').text
    ext = imgpath[imgpath.rindex('.') + 1:]
    objs = root.findall('./object')
    for n, obj in enumerate(objs):
        coords = {o.tag: int(o.text) for o in obj.find('./bndbox').getchildren()}
        tag = obj.find('./name').text
        # print(n, tag, coords)
        save_path = '../vid-tag-cropped/%s/%s-%s.%s' % (tag, filename, n, ext)
        if not os.path.isfile(save_path):
            cropped = crop_file(imgpath, coords['xmin'], coords['ymin'], coords['xmax'], coords['ymax'])
            print(save_path)
            # cropped.show()
            cropped.save(save_path)


def each_annotation():
    for d, subdirs, _files in os.walk('../vid-tag'):
        for subdir in subdirs:
            path = d + '/' + subdir
            if not subdir.startswith('_'):
                for d2, subdirs2, files in os.walk(path):
                    # print(d2, subdirs2, files)
                    for f in files:
                        if f.endswith('.xml'):
                            yield d2 + '/' + f


def process_annotations():
    for filepath in each_annotation():
        # print(filepath)
        process_annotation_file(filepath)


def test_process_annotation():
    cropped_path = '../vid-tag-cropped'
    dirpath = '../vid-tag/cardinalis-cardinalis'
    xmlfile = '2016-10-17-16-51-03.xml'
    filepath = dirpath + '/' + xmlfile
    process_annotation_file(filepath)


def all_tags():
    return [d for d in list(os.walk('../vid-tag'))[0][1] if not d.startswith('_')]


def ensure_all_vid_tag_cropped_dirs():
    for tag in all_tags():
        path = '../vid-tag-cropped/' + tag
        if not os.path.isdir(path):
            os.makedirs(path)


if __name__ == '__main__':
    ensure_all_vid_tag_cropped_dirs()
    process_annotations()
